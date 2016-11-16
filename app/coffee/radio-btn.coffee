radioBtn = require 'jade/radio-btn'

module.exports = class RadioBtn

  constructor: (@origRadioBtn) ->
    @origRadioBtn.style.display = 'none'
    $node = $('<div class="lexi-ui radio-btn" />')
    if @origRadioBtn.getAttribute('checked')? then $node.addClass('active')
    $(@origRadioBtn).after $node

    # Get all the radios in this group
    $radioGroup = $("input[name=#{@origRadioBtn.getAttribute('name')}]")

    # When any of them change..
    $radioGroup.on 'click', (e)=>
      if e.currentTarget == @origRadioBtn
        $node.addClass 'active'
        # $(@origRadioBtn).attr('checked', "checked")
        $(@origRadioBtn).trigger 'change'

        # if 0 == 0
          # $(@origRadioBtn).trigger 'click'
      else
        $node.removeClass 'active'

    $node.on 'click', ()=>
      $(@origRadioBtn).trigger 'click'
