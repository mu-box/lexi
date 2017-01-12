dropDown = require 'jade/drop-down'

module.exports = class DropDown

  constructor: (@el) ->
    @prepareToBuild()

  build : (@$select, @options, additionalClasses) ->
    @$select.css display:'none'
    @$trigger = $('<div class="lexi-ui drop-down-trigger"><div class="txt"></div></div>')
    @$trigger.addClass additionalClasses
    @setWidth @options
    [@activeOptionId, name] = @getSelectedOptionName( @options )
    $('.txt', @$trigger).text name
    @$trigger.on "mousedown", (e)=>
      # If there is a dropdown active on the page, deactivate
      DropDown.activeDropDown?.hideOptions()
      DropDown.activeDropDown = @

      @openTime = Date.now()
      e.stopPropagation()
      @showOptions()
    @$trigger.on "click", (e)=> e.stopPropagation()
    @$select.after @$trigger

  showOptions : () ->
    @$dropDown = $ dropDown( {options:@options} )
    $('body').append( @$dropDown).css overflow: "hidden"
    # castShadows @$dropDown
    @$checkmark = $ '.checkmark', @$dropDown

    @sizeAndPositionDropdown()

    $(document).on 'mouseup', (e)=>
      # Allow 1/3 of a second after the mousepress in case
      # they're single clicking to open the dropdown
      return if Date.now() - @openTime < 325

      # Mouseup occurs outside the dropdown
      if $(e.target).closest(".drop-down").length == 0
        @hideOptions()

      $target = $(e.target)

      # If release occurs over a valid option
      if $target.is(".option")
        @onOptionClicked $target

    $option = $(".option", @$dropDown)
    $option.on 'mouseover', (e)=> $(e.currentTarget).addClass 'focus'
    $option.on 'mouseout', (e)=>  $(e.currentTarget).removeClass 'focus'
    @addCheckToActiveOption()

  sizeAndPositionDropdown : () ->
    dropdownHeight = @$dropDown.outerHeight()
    pos            = @$trigger.position()
    winHeight      = $(window).height()
    console.log pos
    pos = @$trigger[0].getBoundingClientRect()

    # If dropdown would bleed off bottom of page
    if pos.top + dropdownHeight > winHeight
      top = winHeight - dropdownHeight
    else
      top = pos.top

    # If page is smaller than dropdown
    if winHeight < dropdownHeight
      top = 0
      @$dropDown.css {height: winHeight; overflow: 'scroll'}

    @$dropDown.css {top: top, left: pos.left}

  onOptionClicked : ($target) ->
    @activeOptionId = $target.attr 'data-id'
    @addCheckToActiveOption()
    $target.addClass 'clicked'
    @$select.val @activeOptionId
    @$select.trigger('change')
    setTimeout ()=>
      $target.removeClass 'clicked'
      setTimeout ()=>
        @hideOptions()
      , 30
    , 80

  hideOptions : () ->
    # if DropDown.activeDropDown == @ then DropDown.activeDropDown = null
    $(".option", @$dropDown).off( 'mouseover')
                            .off 'mouseout'
    @$dropDown?.remove()
    $('body').css overflow: "initial"
    $(document).off 'mouseup'

  addCheckToActiveOption : ()->
    if !@activeOptionId?
      $option = $(".option", @$dropDown).first()
    else
      $option = $(".option[data-id='#{@activeOptionId}']", @$dropDown)

    $option.addClass "checked"
    $('.txt', @$trigger).text $option.text()

  destroy : () ->
    @$trigger.off()
    @$trigger.empty()
    $(".option", @$trigger).off()

  val : () -> @activeOptionId


  # ------------------------------------ Helpers

  prepareToBuild : ()->
    elements = []
    @addDropDownChildren @el, elements
    $el = $(@el)
    $el.removeClass 'lexi'
    @build $(@el), elements, $el.attr('class')
    $el.addClass 'lexi'

  addDropDownChildren : (el, ar) ->
    $(el).children().each (i,item)=>
      if item.tagName.toLowerCase() == "optgroup"
        ar.push { name:item.getAttribute('label'), isLabel:true }
        @addDropDownChildren item, ar
      else
        obj = { id:item.getAttribute('value'), name:item.innerHTML }
        if item.getAttribute('selected')?
          obj.selected = true
        ar.push obj


  # Set the min width of the trigger based on the longest option
  setWidth : (options) ->
    longest = 0
    letterWidth = 9.12
    for option in options
      if !option.isLabel
        if option.name.length > longest then longest = option.name.length

    @$trigger.css 'min-width' : longest*letterWidth

  getSelectedOptionName : (options) ->
    for option in options
      # If we haven't found any options yet, and this is not a label, save as default
      if !firstOptionIsFound && !option.isLabel
        firstOptionIsFound = true
        defaultOption = option

      if option.selected
        @activeOptionId = option.id
        return [option.id, option.name]
    #  We didnt find any options that were selected, so return the first option in the list
    return [defaultOption.id, defaultOption.name]
