# --- Test 33. Event handlers with macros. --- #
import nodesnim


Window("test35")

var
  main = Scene("Main")
  node = Button()

node.setText("Hello")
node.setAnchor(0.5, 0.5, 0.5, 0.5)


node@onReady(self):
  echo "hello!"

node@onInput(self, event):
  if event.isInputEventMouseButton() and event.pressed:
    echo "clicked"

node@onClick(self, x, y):
  node.setText("clicked in " & $x & "," & $y & ".")


main.addChild(node)
addMainScene(main)
windowLaunch()
