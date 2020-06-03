import nodesnim


Window("Hello world")

var
  main_obj: SceneObj
  main = Scene("Main", main_obj)

  label_obj: LabelObj
  label = Label("HelloWorld", label_obj)

main.addChild(label)


label.text = "Hello, world!"
label.setTextAlign(0.5, 0.5, 0.5, 0.5)
label.setSizeAnchor(1, 1)

addScene(main)
setMainScene("Main")
windowLaunch()
