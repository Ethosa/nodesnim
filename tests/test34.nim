# --- Test 34. Use Switch node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  switchobj: SwitchObj
  switch = Switch(switchobj)

main.addChild(switch)
switch.move(128, 64)

switch.on_toggle =
  proc(toggled: bool) =  # this called when the user toggles switch.
    echo toggled


addScene(main)
setMainScene("Main")
windowLaunch()
