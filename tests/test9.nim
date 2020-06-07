# --- Test 9. Use Label node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  label = Label()

main.addChild(label)

label.text = "Hello, world!\nsecondline\nThis is a long sentence."  # Change label text.
label.setTextAlign(0.2, 0.5, 0.2, 0.5)  # try to change it ^^.
label.setSizeAnchor(1, 1)
label.color = Color(1f, 1f, 1f)  # default text color.


addScene(main)
setMainScene("Main")
windowLaunch()
