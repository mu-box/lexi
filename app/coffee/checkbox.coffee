Input = require './input'
checkbox = require 'jade/checkbox'

module.exports = class Checkbox extends Input

  constructor: (origCheckbox) ->
    @checkForLabel origCheckbox
    origCheckbox.style.display = 'none'
    @$node = $ checkbox( {} )
    if origCheckbox.getAttribute('checked')? then @$node.addClass('checked')
    $(origCheckbox).after @$node
    @$node.on 'click', ()=>
      @$node.toggleClass 'checked'
      $(origCheckbox).trigger 'click'
    super()
