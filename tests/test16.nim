# --- Test 16. Use EditText node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  edittextobj: EditTextObj
  edittext = EditText(edittextobj)

main.addChild(edittext)

edittext.color = Color(1f, 1f, 1f)  # default text color.
edittext.hint_color = Color(1f, 0.6, 1f)
edittext.resize(512, 256)
edittext.setBackgroundColor(Color(0x212121ff))


addScene(main)
setMainScene("Main")
windowLaunch()
