# --- Test 48. Use Camera3D node. --- #
import nodesnim

Window("camera 3d test")


build:
  - Scene main:
    - Node3D root:
      call translate(2, 2, -5)
      - Camera3D camera:
        call setCurrent()
        call changeTarget(root)
    - GeometryInstance cube:
      translation: Vector3(-1, 0, 2)
      color: Color(122, 133, 144, 0.8)
    - GeometryInstance cube1:
      translation: Vector3(2, 0, -2)
      color: Color(144, 144, 122, 0.8)
    - GeometryInstance cube2:
      translation: Vector3(1, 2.5, 1)
      color: Color(144, 111, 144, 0.8)
    - GeometryInstance sphere:
      translation: Vector3(-1, -1, 1)
      color: Color(144, 77, 144, 1.0)
      geometry: GEOMETRY_SPHERE
    - ProgressBar health:
      call resize(256, 48)
      call setAnchor(0, 1, 0, 1)
      call setProgress(50)
      call setProgressColor(Color("#a77"))
      call setBackgroundColor(Color(222, 222, 222, 0.5))

Input.addKeyAction("forward", "w")
Input.addKeyAction("back", "s")
Input.addKeyAction("left", "a")
Input.addKeyAction("right", "d")

root@on_input(self, event):
  if event.isInputEventMouseMotion() and event.pressed:
    camera.pitch += event.yrel*0.1  # Y
    camera.yaw -= event.xrel*0.1    # X
  if Input.isActionPressed("left"):
    root.translate(camera.front.cross(camera.up).normalized() * -0.1)
  if Input.isActionPressed("right"):
    root.translate(camera.front.cross(camera.up).normalized() * 0.1)
  if Input.isActionPressed("forward"):
    root.translate(camera.front*0.1)
  if Input.isActionPressed("back"):
    root.translate(camera.front*(-0.1))


addMainScene(main)
windowLaunch()
