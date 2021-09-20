# --- Use TileMap ISOMETRIC mode --- #
import nodesnim

Window("Tilemap test", 1024, 640)

var
  tileset = TileSet("assets/tilesets/isometric_desert.png", Vector2(64, 32), GL_RGBA)

build:
  - Scene main:
    - TileMap map:
      call setTileSet(tileset)
      call resizeMap(newVector2(8096, 512), layer_count=4)
      call setMode(TILEMAP_ISOMETRIC)
      call fill(newVector2(1, 0))
      call drawRect(3, 3, 10, 5, newVector2(15, 1))

      # platform
      call drawTile(2, 4, newVector2(0, 27), 1)
      call drawTile(1, 5, newVector2(0, 28), 1)

      # cross
      call drawTile(4, 6, newVector2(14, 13), 1)
      call drawTile(3, 7, newVector2(14, 14), 1)

      # sign
      call drawTile(4, 5, newVector2(11, 12), 1)
      call drawTile(4, 5, newVector2(11, 13), 2)
      call drawTile(4, 5, newVector2(11, 14), 3)

      # magic
      call drawTile(5, 10, newVector2(2, 33), 1)
      call drawTile(6, 11, newVector2(3, 33), 1)
      call drawTile(4, 11, newVector2(2, 34), 1)
      call drawTile(5, 12, newVector2(3, 34), 1)

addMainScene(main)
windowLaunch()
