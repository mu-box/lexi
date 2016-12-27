label = require 'jade/label'

module.exports = class Input

  constructor: () ->
    @addLabel()

  checkForLabel : (el) ->
    parent = el.parentNode
    # If there is a label
    if parent.tagName.toUpperCase() == 'LABEL'
      @label  = parent.textContent
      # If the label if before the input (check to see if the first letter
      # of the innerHTML == the first letter of the text content)
      if parent.innerHTML[0] == parent.textContent[0]
        @insertLabelBefore = true

      $el     = $(el)
      $parent = $(parent)
      $el.detach()
      $parent.replaceWith $el

  addLabel : () ->
    if @label?
      $label = $ "<div class='label' data-content='#{@label}' />"
      $label = $ label( {txt:@label, isBefore:@insertLabelBefore} )

      if @insertLabelBefore
        @$node.prepend $label
      else
        @$node.append $label
