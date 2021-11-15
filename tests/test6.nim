# --- Test 6. Work with 2D nodes. --- #
import
  nodesnim,
  unittest


suite "Work with 2D nodes.":
  
  test "Setup window":
    Window("2D nodes test", 1024, 640)


  test "Register events":
    addButtonAction("left", BUTTON_LEFT)
    addKeyAction("w", "w")
    addKeyAction("a", "a")
    addKeyAction("s", "s")
    addKeyAction("d", "d")


  test "Setup scene":
    build:
      - Scene main
    addMainScene(main)


  test "Node2D test":
    build:
      - Node2D node2d(name: "2d node")
    getSceneByName("main").addChild(node2d)


  test "Sprite test":
    build:
      - Sprite sprite:
        centered: true
        call loadTexture("assets/anim/2.jpg")
        call move(80, 80)
    getSceneByName("main").addChild(sprite)


  test "AnimatedSprite test":
    build:
      - AnimatedSprite animation:
        centered: false
        z_index: -10
        call:
          addFrame("default", load("assets/anim/0.jpg"))
          addFrame("default", load("assets/anim/1.jpg"))
          addFrame("default", load("assets/anim/2.jpg"))
          addFrame("default", load("assets/anim/3.jpg"))
          addFrame("default", load("assets/anim/4.jpg"))
          play(name = "", backward = false)
          setSpeed("default", 5)  # name, frames-per-second
    getSceneByName("main").addChild(animation)


  test "YSort test":
    var image = load("assets/anim/2.jpg")
    build:
      - YSort sort:
        z_index: 1
        call move(720, 80)
        - Sprite s1:
          filter: Color("#6644ff")
          call setTexture(image)
        - Sprite s2:
          filter: Color("#997799")
          call setTexture(image)
          call move(0, 80)
        - Sprite s3:
          filter: Color("#9f9")
          call setTexture(image)
          call move(0, 160)
    getSceneByName("main").addChild(sort)

  test "KinematicBody2D test":
    build:
      - KinematicBody2D body:
        - CollisionShape2D collision:
          call setShapeTypePolygon(Vector2(0, 0), Vector2(15, 5), Vector2(28, 15),
                                   Vector2(35, 25), Vector2(5, 45))
      - CollisionShape2D rect_collision:
        call resize(160, 40)
        call move(100, 200)
      - CollisionShape2D polygon_collision:
        call setShapeTypePolygon(Vector2(0, 0), Vector2(150, 65), Vector2(25, 150))
        call move(300, 200)
      - CollisionShape2D circle_collision:
        call setShapeTypeCircle(0, 0, 64)
        call move(100, 300)
    body@onProcess(self):
      if isActionPressed("left"):
        let
          mouse_pos = body.getGlobalMousePosition()
          distance = body.global_position.distance(mouse_pos)
          direction = body.global_position.directionTo(mouse_pos)
          speed = 3f
        if distance >= 5:
          body.moveAndCollide(direction*speed)
    getSceneByName("main").addChildren(body, rect_collision, polygon_collision, circle_collision)


  test "Camera2D test":
    build:
      - KinematicBody2D player:
        z_index: 50
        - Sprite player_sprite:
          z_index: 50
          centered: true
          filter: Color("#555")
          call loadTexture("assets/anim/2.jpg")
      - Camera2D camera:
        call:
          setTarget(player)
          setLimit(-2048, -1024, 2048, 1024)
          setCurrent()
          enableSmooth()
    player@onProcess(self):
      if isActionPressed("w"):
        player.move(0, -10)
      elif isActionPressed("s"):
        player.move(0, 10)
      if isActionPressed("a"):
        player.move(-10, 0)
      elif isActionPressed("d"):
        player.move(10, 0)
    getSceneByName("main").addChildren(player, camera)


  test "TileMap 2d test":
    var tileset = TileSet("assets/tilesets/land.png", Vector2(64, 64), GL_RGBA)
    build:
      - TileMap map:
        z_index: -100
        call:
          setTileSet(tileset)
          move(-2048, -1024)
          #                 map size   layer count
          resizeMap(Vector2(512, 128), 1)
          fill(Vector2(1, 0))
          drawRect(3, 3, 10, 5, Vector2(9, 7))
          drawTile(0, 0, Vector2(3, 0))
          drawTile(1, 0, Vector2(7, 4.5))
          drawTile(0, 1, Vector2(6.5, 5))
          drawTile(1, 1, Vector2(7, 5))
    getSceneByName("main").addChild(map)


  test "TileMap isometric test":
    var tileset = TileSet("assets/tilesets/isometric_desert.png", Vector2(64, 32), GL_RGBA)
    build:
      - TileMap map:
        z_index: -80
        call:
          setMode(TILEMAP_ISOMETRIC)
          setTileSet(tileset)
          move(-2048, -1024)
          #                         map size   layer count
          resizeMap(Vector2(32, 32), layer_count=4)
          fill(Vector2(1, 0))
          drawRect(3, 3, 10, 5, Vector2(15, 1))

          # platform
          drawTile(2, 4, Vector2(0, 27), 1)
          drawTile(1, 5, Vector2(0, 28), 1)

          # cross
          drawTile(4, 6, Vector2(14, 13), 1)
          drawTile(3, 7, Vector2(14, 14), 1)

          # sign
          drawTile(4, 5, Vector2(11, 12), 1)
          drawTile(4, 5, Vector2(11, 13), 2)
          drawTile(4, 5, Vector2(11, 14), 3)

          # magic
          drawTile(5, 10, Vector2(2, 33), 1)
          drawTile(6, 11, Vector2(3, 33), 1)
          drawTile(4, 11, Vector2(2, 34), 1)
          drawTile(5, 12, Vector2(3, 34), 1)
    getSceneByName("main").addChild(map)


  test "Launch window":
    windowLaunch()
