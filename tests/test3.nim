# --- Test 3. Window events handling. --- #
import nodesnim


Window("newwindow")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  nodeobj: NodeObj
  node = Node("My node", nodeobj)

main.addChild(node)

# Bind actions:
Input.addKeyAction("forward", "w")
Input.addKeyAction("backward", "s")
Input.addKeyAction("left", "a")
Input.addKeyAction("right", "d")
Input.addButtonAction("click", BUTTON_LEFT)
Input.addButtonAction("release", BUTTON_RIGHT)


node.on_process =
  proc(self: NodePtr) =  # This called every frame.
    if Input.isActionPressed("forward"):  # returns true, when user press "w"
      echo "forward"
    if Input.isActionPressed("backward"):  # returns true, when user press "s"
      echo "backward"
    if Input.isActionPressed("left"):  # returns true, when user press "a"
      echo "left"
    if Input.isActionPressed("right"):  # returns true, when user press "d"
      echo "right"

    if Input.isActionJustPressed("click"):  # returns true, when the user clicks the left button one time.
      echo "clicked!"

    if Input.isActionReleased("release"):  # returns true, when the user no more press on the right button.
      echo "release!"

node.on_input =
  proc(self: NodePtr, event: InputEvent) =  # This called only on user input.
    if event.isInputEventMouseButton() and event.pressed:
      echo "hi"


addScene(main)
setMainScene("Main")
windowLaunch()
