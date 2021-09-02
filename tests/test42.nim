# --- Test 42. Use Scene builder. --- #
import nodesnim

Window("scene builder")

build:
  - Scene scene:
    name: "Main scene"
    - Vbox background:  # Instead of var background = Vbox()
      call setBackgroundColor(Color(21, 33, 48))  # You can change params without `objname`.param = value syntax.
      call setSizeAnchor(1.0, 0.1)  # You can also call any method without `objname`.method(args) syntax. :eyes:
      call setAnchor(0.5, 0.5, 0.5, 0.5)

echo background.size_anchor

addMainScene(scene)
windowLaunch()
