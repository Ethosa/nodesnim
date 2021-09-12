# --- Test 46. Use TileMap node. --- #
import nodesnim

Window("Tilemap test")

var
  tileset = TileSet("assets/tilesets/land.png", Vector2(64, 64), GL_RGBA)

build:
  - Scene main:
    - TileMap map:
      call setTileSet(tileset)
      call resizeMap(Vector2(10000, 10000))
      call fillTile(Vector2(1, 0))
      call drawTile(0, 0, Vector2(3, 0))
      call drawTile(1, 0, Vector2(7, 4.5))
      call drawTile(0, 1, Vector2(6.5, 5))
      call drawTile(1, 1, Vector2(7, 5))

addMainScene(main)
windowLaunch()
