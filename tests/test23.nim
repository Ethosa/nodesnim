# --- Test 23. Use Popup node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  popupobj: PopupObj
  popup = Popup(popupobj)  # Create Popup node pointer.

  boxobj: VBoxObj
  box = VBox(boxobj)

  labelobj: LabelObj
  label = Label(labelobj)

  smthnodeobj: NodeObj
  smthnode = Node(smthnodeobj)


label.setText("Hello")
label.setTextAlign(0.5, 0.5, 0.5, 0.5)
box.setChildAnchor(0.5, 0.1, 0.5, 0.1)
box.setSizeAnchor(1, 1)

popup.addChild(box)
box.addChild(label)
main.addChild(popup)
main.addChild(smthnode)


Input.addKeyAction("space", K_SPACE)
smthnode.process =
  proc() =
    if Input.isActionJustPressed("space"):
      if popup.visible:
        popup.hide()
      else:
        popup.show()


addScene(main)
setMainScene("Main")
windowLaunch()
