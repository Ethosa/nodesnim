# --- Test 16. Use EditText node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  edittext = EditText()

main.addChild(edittext)

edittext.resize(512, 256)
edittext.setBackgroundColor(Color(0x212121ff))
edittext.setTextAlign(0.5, 0.5, 0.5, 0.5)
edittext.setAnchor(0.5, 0.5, 0.5, 0.5)


addScene(main)
setMainScene("Main")
windowLaunch()
