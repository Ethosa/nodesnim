import
  nodesnim,
  random

Window("Roguelike", 480, 240)
env.setBackgroundColor(Color("#e0f8cf"))

var
  tileset = TileSet("assets/colored_tilemap.png", Vector2(16, 16), GL_RGBA)
  charapter = load("assets/player.png", GL_RGBA)

const
  PLAYER_SPEED: float = 4
  LEVEL_WIDTH: float = 100
  PLAYER_SIZE: float = 16

build:
  - Scene main:
    - TileMap map:
      call setTileSet(tileset)
      call resizeMap(newVector2(LEVEL_WIDTH, 15), 2)

    # Player
    - KinematicBody2D player:
      call move(300, 120)
      - Sprite player_sprite:
        call setTexture(charapter)
      - CollisionShape2D player_collision:
        call resize(PLAYER_SIZE, PLAYER_SIZE)
        call move(-8, -8)

    # Collision
    - CollisionShape2D top:
      call resize(LEVEL_WIDTH*16, 1)
      call move(0, -1)
    - CollisionShape2D bottom:
      call resize(LEVEL_WIDTH*16, 1)
      call move(0, 240)
    - CollisionShape2D left:
      call resize(1, 240)
      call move(PLAYER_SIZE, 0)
    - CollisionShape2D right:
      call resize(1, 240)
      call move(LEVEL_WIDTH*16, 0)

    - Camera2D camera:
      call setLimit(0, 0, LEVEL_WIDTH*16, 240)
      call setCurrent()
      call setTarget(player)
      call enableSmooth()

# Draw grass
for i in 0..512:
  map.drawTile(rand(99), rand(14), newVector2(0, 1), 1)

# Draw trees
for i in 0..128:
    map.drawTile(rand(99), rand(14), newVector2(rand(13..16).float, 0), 1)

# Draw houses
for i in 0..32:
    var
      pos = Vector2(rand(99).float, rand(14).float)
      collider = CollisionShape2D()
    map.drawTile(pos.x.int, pos.y.int, newVector2(rand(13..16).float, 2), 1)
    collider.resize(PLAYER_SIZE, PLAYER_SIZE)
    collider.move(pos.x*PLAYER_SIZE, pos.y*PLAYER_SIZE)
    main.addChild(collider)


# Movement
addKeyAction("forward", "w")
addKeyAction("backward", "s")
addKeyAction("right", "d")
addKeyAction("left", "a")

player@onProcess(self):
  if isActionPressed("right"):
    player.moveAndCollide(Vector2(PLAYER_SPEED, 0))
  elif isActionPressed("left"):
    player.moveAndCollide(Vector2(-PLAYER_SPEED, 0))

  if isActionPressed("forward"):
    player.moveAndCollide(Vector2(0, -PLAYER_SPEED))
  elif isActionPressed("backward"):
    player.moveAndCollide(Vector2(0, PLAYER_SPEED))


addMainScene(main)
windowLaunch()
