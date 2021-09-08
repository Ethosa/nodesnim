# --- Test 32. Use Switch node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  switch = Switch()

main.addChild(switch)
switch.move(128, 64)

switch.on_toggle =
  proc(self: SwitchRef, toggled: bool) =  # this called when the user toggles switch.
    echo toggled


addScene(main)
setMainScene("Main")
windowLaunch()
