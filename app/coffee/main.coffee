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
      selector = "input, select"
    else
      selector = ".lexi input, select"

    # For each element with the `.lexi` class, create a lexi element
    $(selector, $el).each (i,el)=>
      if el.style.display != 'none' # Don't lexify if hidden (or already lexified and hidden)
        tagName = el.tagName.toLowerCase()
        if tagName == 'select'
          @createDropDown el
        else if tagName == 'input'
          switch el.getAttribute('type')
            when 'radio'
              @createRadioBtn el
            when 'checkbox'
              @createCheckbox el
  createRadioBtn : (el) ->
    new RadioBtn el

  createDropDown : (el) ->
    new DropDown el

  createCheckbox : (el) ->
    new Checkbox el


window.nanobox ||= {}
nanobox.Lexi = Lexi
new nanobox.Lexi()
