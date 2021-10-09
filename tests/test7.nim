# --- Test 7. Work with 3D nodes. --- #
import
  nodesnim,
  unittest


suite "Work with 3D nodes.":
  
  test "Setup window":
    Window("3D nodes test", 1024, 640)


  test "Setup scene":
    build:
      - Scene main
    addMainScene(main)


  test "Register events":
    addKeyAction("forward", "w")
    addKeyAction("back", "s")
    addKeyAction("left", "a")
    addKeyAction("right", "d")


  test "GeometryInstance test":
    build:
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
      - GeometryInstance cylinder:
        translation: Vector3(2, -1, 1)
        color: Color(144, 77, 144, 1.0)
        geometry: GEOMETRY_CYLINDER
    getSceneByName("main").addChildren(cube, cube1, cube2, sphere, cylinder)


  test "Camera3D test":
    build:
      - Node3D root:
        call translate(2, 2, -5)
        - Camera3D camera:
          call setCurrent()
          call changeTarget(root)
    root@onInput(self, event):
      if event.isInputEventMouseMotion() and event.pressed:
        camera.rotate(-event.xrel*0.25, event.yrel*0.25)

    root@onProcess(self):
      if isActionPressed("left"):
        root.translate(camera.right * -0.1)
      if isActionPressed("right"):
        root.translate(camera.right * 0.1)
      if isActionPressed("forward"):
        root.translate(camera.front*0.1)
      if isActionPressed("back"):
        root.translate(camera.front*(-0.1))
    getSceneByName("main").addChild(root)


  test "Sprite3D test":
    build:
      - Sprite3D sprite:
        call loadTexture("assets/anim/2.jpg", GL_RGB)
        call translate(-3, -2, 2)

    sprite@onProcess(self):
      sprite.rotateY(0.5)
    getSceneByName("main").addChild(sprite)


  test "Launch window":
    windowLaunch()
