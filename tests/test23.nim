# --- Test 23. Use Popup node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  popup = Popup()  # Create Popup node pointer.

  box = VBox()

  label = Label()

  smthnode = Node()


label.setText("Hello")
label.setTextAlign(0.5, 0.5, 0.5, 0.5)
box.setChildAnchor(0.5, 0.1, 0.5, 0.1)
box.setSizeAnchor(1, 1)

popup.addChild(box)
box.addChild(label)
main.addChild(popup)
main.addChild(smthnode)


Input.addKeyAction("space", K_SPACE)
smthnode.on_process =
  proc(self: NodeRef) =
    if Input.isActionJustPressed("space"):
      if popup.visible:
        popup.hide()
      else:
        popup.show()


addScene(main)
setMainScene("Main")
windowLaunch()
