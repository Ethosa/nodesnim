# --- Test 17. Use RichLabel node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  label = RichLabel()

main.addChild(label)

label.text = clrtext("Hello, world!\nsecondline\nThis is a long sentence.")  # Change label text.
label.setTextAlign(0.2, 0.5, 0.2, 0.5)  # try to change it ^^.
label.setSizeAnchor(1, 1)
label.text.setColor(0, 4, Color(1, 0.6, 1))
label.text.setColor(8, 16, Color(0xffccaaff'u32))


addScene(main)
setMainScene("Main")
windowLaunch()
