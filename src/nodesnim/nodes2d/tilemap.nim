# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/enums,
  ../core/input,
  ../core/tileset,

  ../nodes/node,
  node2d


type
  TileMapObj* = object of Node2DObj
    mode*: TileMapMode
    map_size*: tuple[x, y, z: int]
    tileset*: TileSetObj
    map*: seq[ref Vector2Obj]
  TileMapRef* = ref TileMapObj


proc TileMap*(name: string = "TileMap"): TileMapRef =
  ## Creates a new TileMap object.
  runnableExamples:
    var mytilemap = TileMap("MyTileMap")
  nodepattern(TileMapRef)
  node2dpattern()
  result.mode = TILEMAP_2D
  result.map_size = (x: 25, y: 25, z: 2)
  result.kind = TILEMAP_NODE
  newSeq(result.map, result.map_size.x*result.map_size.y*result.map_size.z)


method draw*(self: TileMapRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  procCall self.Node2DRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
  var viewport = @[
      abs(x + w/2).int div self.tileset.grid.x.int, abs(y - h/2).int div self.tileset.grid.y.int,
      abs(x - w/2).int div self.tileset.grid.x.int, abs(y + h/2).int div self.tileset.grid.y.int]
  if viewport[3] >= self.map_size.y:
    viewport[3] = self.map_size.y-1
  if viewport[2] >= self.map_size.x:
    viewport[2] = self.map_size.x-1

  glEnable(GL_TEXTURE_2D)
  glColor4f(1, 1, 1, 1)
  case self.mode
  of TILEMAP_2D:
    glEnable(GL_DEPTH_TEST)
    for z in 0..<self.map_size.z:
      for x1 in viewport[0]..viewport[2]:
        for y1 in viewport[1]..viewport[3]:
          let pos = x1+y1*self.map_size.x + self.map_size.x*self.map_size.y*z
          if not self.map[pos].isNil():
            let
              posx = x + self.tileset.grid.x*x1.float
              posy = y - self.tileset.grid.y*y1.float
            self.tileset.draw(self.map[pos].x, self.map[pos].y, posx, posy, self.z_index_global + z.float)
    glDisable(GL_TEXTURE_2D)
  of TILEMAP_ISOMETRIC:
    for z in 0..<self.map_size.z:
      for y1 in viewport[1]..viewport[3]:
        for x1 in viewport[0]..viewport[2]:
          let
            pos = x1+y1*self.map_size.x + self.map_size.x*self.map_size.y*z
          if not self.map[pos].isNil():
            let
              posx = x + GLfloat((x1.GLfloat * self.tileset.grid.x  / 2) + (y1.GLfloat * self.tileset.grid.x  / 2))
              posy = y - GLfloat((y1.GLfloat * self.tileset.grid.y / 2) - (x1.GLfloat * self.tileset.grid.y / 2)) - h/2
            self.tileset.draw(self.map[pos].x, self.map[pos].y, posx, posy - self.tileset.grid.y*z.GLfloat, self.z_index_global)
  glDisable(GL_DEPTH_TEST)

method drawTile*(self: TileMapRef, x, y: int, tile_pos: Vector2Obj, layer: int = 0) {.base.} =
  ## Changes map tile at `x`,`y` point to tile from tileset at `tile_pos` point.
  self.map[x+y*self.map_size.x + self.map_size.x*self.map_size.y*layer] = newVector2(tile_pos)

method drawRect*(self: TileMapRef, x, y, w, h: int, tile_pos: Vector2Obj, layer: int = 0) {.base.} =
  for x1 in x..x+w:
    for y1 in y..y+h:
      self.drawTile(x1, y1, tile_pos, layer)

method fill*(self: TileMapRef, tile_pos: Vector2Obj, layer: int = 0) {.base.} =
  ## Fills the map with a tile at `tile_pos` position.
  for x in 0..<self.map_size.x.int:
    for y in 0..<self.map_size.y.int:
      self.drawTile(x, y, tile_pos, layer)

method resizeMap*(self: TileMapRef, size: Vector2Obj, layer_count: int = 2) {.base.} =
  ## Changes map size to `size`.
  self.map_size = (x: size.x.int, y: size.y.int, z: layer_count)
  self.map.setLen(self.map_size.x*self.map_size.y*layer_count)

method setMode*(self: TileMapRef, mode: TileMapMode) {.base.} =
  ## Changes drawing mode.
  self.mode = mode

method setTileSet*(self: TileMapRef, tileset: TileSetObj) {.base.} =
  ## Changes current tileset.
  self.tileset = tileset
