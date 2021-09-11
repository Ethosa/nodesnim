# --- Test 37. Use GeometryInstance node. --- #
import nodesnim


Window("smth")

build:
  - Scene scene:
    - GeometryInstance geometry1:
      translation: Vector3(1, 0, 5)
      color: Color(144, 133, 122, 0.8)
    - Sprite sprite:
      call setTexture(load("assets/anim/2.jpg"))
      call move(96, 96)
    - GeometryInstance geometry2:
      translation: Vector3(-1, 0, 2)
      color: Color(122, 133, 144, 0.8)
    - GeometryInstance geometry3:
      translation: Vector3(1, 0, 2)
      color: Color(144, 111, 144)
      geometry: GEOMETRY_SPHERE
    - Button button:
      text: stext"Hello! ^^"
      call resize(256, 64)
      call setAnchor(0.5, 0.5, 0.5, 0.5)

geometry1@on_input(self, event):
  if event.isInputEventMouseMotion() and event.pressed:
    geometry1.rotateX(-event.yrel)
    geometry1.rotateY(-event.xrel)
    geometry2.rotateX(event.yrel)
    geometry2.rotateY(-event.xrel)
    geometry3.rotateX(event.yrel)
    geometry3.rotateY(-event.xrel)

addMainScene(scene)
windowLaunch()
