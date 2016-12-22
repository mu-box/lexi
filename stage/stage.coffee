lexify()
$output = $(".output")

updateOutput = (txt) ->
  $output.text "#{$output.text()}\n#{txt}"

$("select").on 'change', (e)->
  id  = e.currentTarget.getAttribute 'id'
  val =  e.currentTarget.value
  updateOutput "select : #{id} changed to : #{val}"

$("input[type='radio']").on 'click', (e)->
  groupName = e.currentTarget.getAttribute "name"
  val       = e.currentTarget.getAttribute "value"
  updateOutput "(o) the #{val} radio from the #{groupName} group was just selected"

$("input[type='checkbox']").on 'click', (e)->
  val = if e.currentTarget.checked then '[√] A checkbox was just checked!' else '[ ] A checkbox was just unchecked.'
  updateOutput val
