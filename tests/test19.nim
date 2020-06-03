# --- Test 19. Use RichEditText node. --- #
import
  strutils,
  nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  labelobj: RichEditTextObj
  label = RichEditText(labelobj)

main.addChild(label)

label.setSizeAnchor(1, 1)

label.on_process =
  proc(self: NodePtr) =
    label.text.setColor(Color(1f, 1f, 1f))
    label.text.setUnderline(false)

    # Nim highlight
    var start_position = ($label.text).find("Nim")
    while start_position > -1:
      label.text.setColor(start_position, start_position+2, Color(0xaa99ffff'u32))
      start_position = ($label.text).find("Nim", start_position+2)

    # word underline
    if label.text.len() > 0:
      let (s, e) = label.getWordPositionUnderMouse()
      if s != -1:
        label.text.setUnderline(s, e, true)


addScene(main)
setMainScene("Main")
windowLaunch()
