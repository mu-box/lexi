module.exports = class Checkbox

  constructor: (origCheckbox) ->
    origCheckbox.style.display = 'none'
    $node = $('<div class="lexi-ui checkbox" />')
    if origCheckbox.getAttribute('checked')? then $node.addClass('checked')
    $(origCheckbox).after $node
    $node.on 'click', ()->
      $node.toggleClass 'checked'
      $(origCheckbox).trigger 'click'
