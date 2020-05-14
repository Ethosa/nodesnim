# --- Test 6. Events handling. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  mainobj: SceneObj
  main_scene = Scene("Main", mainobj)

  colorrectobj: ColorRectObj
  colorrect = ColorRect(colorrectobj)

main_scene.addChild(colorrect)

# for every node
colorrect.enter =
  proc() =  # This called when scene changed.
    echo "Hello!"
colorrect.ready =
  proc() =  # This called when the scene changed and the `enter` was called.
    echo "I'm ready."
colorrect.input =
  proc(event: InputEvent) =  # This called on user input.
    discard
colorrect.process =
  proc() =  # This called every frame.
    discard
colorrect.exit =
  proc() =  # This called when exit from the scene.
    echo "bye :("

# only for control nodes:
colorrect.mouse_enter =
  proc(x, y: float) =  # This called when a mouse enters the node.
    echo "Entered in color rect."
colorrect.mouse_exit =
  proc() =  # This called when a mouse exits from the node.
    echo "Outed from color rect."

window.setMainScene(main_scene)
window.launch()
