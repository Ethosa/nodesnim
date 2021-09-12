# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/enums,
  ../core/input,
  ../core/tileset,

  ../nodes/node,
  node2d,
  math


type
  TileMapObj* = object of Node2DObj
    map_size*: tuple[x, y: int]
    tileset*: TileSetObj
    map*: seq[seq[tuple[x, y: float]]]
  TileMapRef = ref TileMapObj


proc TileMap*(name: string = "TileMap"): TileMapRef =
  ## Creates a new TileMap object.
  runnableExamples:
    var mytilemap = TileMap("MyTileMap")
  nodepattern(TileMapRef)
  node2dpattern()
  result.map_size = (x: 25, y: 25)
  result.map = @[]
  result.map.setLen(result.map_size.x)
  for x in 0..<result.map_size.x:
    result.map[x].setLen(result.map_size.x)


method draw*(self: TileMapRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  procCall self.Node2DRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
  var viewport = @[
      abs(x + w/2).int div self.tileset.grid.x.int, abs(y - h/2).int div self.tileset.grid.y.int,
      abs(x - w/2).int div self.tileset.grid.x.int,abs(y + h/2).int div self.tileset.grid.y.int]
  if viewport[2] >= self.map_size.x:
    viewport[2] = self.map_size.x-1
  if viewport[3] >= self.map_size.y:
    viewport[3] = self.map_size.y-1

  for x1 in viewport[0]..viewport[2]:
    for y1 in viewport[1]..viewport[3]:
      let
        posx = x + self.tileset.grid.x*x1.float
        posy = y - self.tileset.grid.y*y1.float
      self.tileset.draw(self.map[x1][y1].x, self.map[x1][y1].y, posx, posy)

method drawTile*(self: TileMapRef, x, y: int, tile_pos: Vector2Obj) {.base.} =
  self.map[x][y] = (x: tile_pos.x, y: tile_pos.y)

method fillTile*(self: TileMapRef, tile_pos: Vector2Obj) {.base.} =
  for x in 0..<self.map_size.x.int:
    for y in 0..<self.map_size.y.int:
      self.map[x][y] = (x: tile_pos.x, y: tile_pos.y)

method resizeMap*(self: TileMapRef, size: Vector2Obj) {.base.} =
  self.map_size = (x: size.x.int, y: size.y.int)
  self.map = @[]
  self.map.setLen(self.map_size.x)
  for x in 0..<self.map_size.x:
    self.map[x].setLen(self.map_size.x)

method setTileSet*(self: TileMapRef, tileset: TileSetObj) {.base.} =
  self.tileset = tileset
