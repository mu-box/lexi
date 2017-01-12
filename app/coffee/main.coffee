DropDown = require './drop-down'
RadioBtn = require './radio-btn'
Checkbox = require './checkbox'

module.exports = class Lexi

  constructor: () ->
    window.Lexi = @
    window.lexify = @lexify

  lexify : ($el) =>
    # If there is no context provided, search the whole body
    if !$el? then $el = $('body')
    return if $el.length == 0

    # If they've passed in the element with the class lexi
    if $el.hasClass 'lexi'
      selector = "input, select, textarea"
    else
      selector = ".lexi input, select, textarea"

    # For each element with the `.lexi` class, create a lexi element
    $(selector, $el).each (i,el)=>
      if el.style.display != 'none' # Don't lexify if hidden (or already lexified and hidden)
        tagName = el.tagName.toLowerCase()
        if tagName == 'select'
          new DropDown el
        else if tagName == 'textarea'
          @markTextArea el
        else if tagName == 'input'
          switch el.getAttribute('type')
            when 'radio'
              new RadioBtn el
            when 'checkbox'
              new Checkbox el
            else
              @markInput el

  markInput    : (el) -> $(el).addClass 'lexi-input'
  markTextArea : (el) -> $(el).addClass 'lexi-textarea'

window.nanobox ||= {}
nanobox.Lexi = Lexi
new nanobox.Lexi()
