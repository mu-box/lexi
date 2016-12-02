DropDown = require './drop-down'
RadioBtn = require './radio-btn'

module.exports = class Lexi

  constructor: () ->
    window.Lexi = @
    window.lexify = @lexify

  lexify : ($el) =>
    # If there is no context provided, search the whole body
    if !$el? then $el = $('body')

    # For each element with the `.lexi` class, create a lexi element
    $(".lexi", $el).each (i,el)=>
      if el.style.display != 'none' # Don't lexify if hidden (or already lexified and hidden)
        tagName = el.tagName.toLowerCase()
        if tagName == 'select'
          @createDropDown el
        else if tagName == 'input'
          switch el.getAttribute('type')
            when 'radio'
              @createRadioBtn el
  createRadioBtn : (el) ->
    new RadioBtn el

  createDropDown : (el) ->
    new DropDown el



window.nanobox ||= {}
nanobox.Lexi = Lexi
new nanobox.Lexi()
