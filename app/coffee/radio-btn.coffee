Input = require './input'
radiobtn = require 'jade/radiobtn'

module.exports = class RadioBtn extends Input

  constructor: (@origRadioBtn) ->
    @checkForLabel @origRadioBtn
    @origRadioBtn.style.display = 'none'

    @$node = $ radiobtn( {} )
    if @origRadioBtn.getAttribute('checked')? then @$node.addClass('active')
    $(@origRadioBtn).after @$node

    # Get all the radios in this group
    $radioGroup = $("input[name=#{@origRadioBtn.getAttribute('name')}]")

    # When any of them change..
    $radioGroup.on 'click', (e)=>
      if e.currentTarget == @origRadioBtn
        @$node.addClass 'active'
        # $(@origRadioBtn).attr('checked', "checked")
        $(@origRadioBtn).trigger 'change'

        # if 0 == 0
          # $(@origRadioBtn).trigger 'click'
      else
        @$node.removeClass 'active'

    @$node.on 'click', ()=>
      $(@origRadioBtn).trigger 'click'
    super()
