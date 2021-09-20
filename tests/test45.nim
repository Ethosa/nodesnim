# --- Test 45. Use TileMap node. --- #
import nodesnim

Window("Tilemap test")

var
  tileset = TileSet("assets/tilesets/land.png", Vector2(64, 64), GL_RGBA)

build:
  - Scene main:
    - TileMap map:
      call setTileSet(tileset)
      #                         map size   layer count
      call resizeMap(newVector2(8096, 512), 1)
      call fill(newVector2(1, 0))
      call drawRect(3, 3, 10, 5, newVector2(9, 7))
      call drawTile(0, 0, newVector2(3, 0))
      call drawTile(1, 0, newVector2(7, 4.5))
      call drawTile(0, 1, newVector2(6.5, 5))
      call drawTile(1, 1, newVector2(7, 5))

addMainScene(main)
windowLaunch()
