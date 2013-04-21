HTML = $.trim """
  <div id="olark_math_container" class="hbl_pal_main_bg"
      style="display: none; position: fixed; width: 200px">
    <span id="olark_math_title" style="position: absolute; top: -20px; font-size: 14px">
      Need to enter some math?
    </span>
    <span class="mathquill-editable" style="display: block; padding: 5px">
      f(x) = x^2 + 3x + 2
    </span>
  </div>
"""

has_mathed = false
initialized = false
olark_math_container = null
olark_math = null

olark 'api.box.onShow', ->
  return if initialized
  initialized = true

  olark_math_container = $(HTML).appendTo 'body'
  olark_math = olark_math_container.find('.mathquill-editable')
  olark_math.mathquill 'editable'

  olark_input = $('#habla_wcsend_input')
  olark_input.on 'focus', ->
    olark_window = $('#habla_window_div')
    offs_right = $(window).width() - olark_input.offset().left + 10
    offs_bottom = olark_input.offsetParent().outerHeight() - olark_input.position().top - olark_input.outerHeight()

    olark_math.css
      borderColor: olark_input.css('borderColor')
      color:       olark_input.css('color')
      fontSize:    olark_input.css('fontSize')
      height:      olark_input.outerHeight() - 12

    olark_math_container.css(
      right:  offs_right
      bottom: offs_bottom
      height: olark_input.outerHeight()
    ).show()

  olark_math.one 'click', ->
    has_mathed = true
    olark_math.mathquill 'latex', ''

olark 'api.box.onHide', ->
  olark_math_container.hide() if olark_math_container

olark 'api.box.onShrink', ->
  olark_math_container.hide() if olark_math_container

olark 'api.chat.onMessageToOperator', (event) ->
  return unless olark_math && has_mathed && olark_math.mathquill('latex') isnt ''
  olark 'api.chat.sendNotificationToOperator',
    body: "math: #{olark_math.mathquill('latex')}"

  olark_math.mathquill 'latex', ''
  olark_math.removeClass 'hasCursor'
