# --- Test 34. Use Switch node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  switch = Switch()

main.addChild(switch)
switch.move(128, 64)

switch.on_toggle =
  proc(toggled: bool) =  # this called when the user toggles switch.
    echo toggled


addMainScene(main)
windowLaunch()
