# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/image,

  vector2,
  exceptions


type
  TileSetObj* = ref object
    grid*, size*: Vector2Obj
    texture*: Gluint

# --- Public --- #
proc TileSet*(img: string, tile_size: Vector2Obj, mode: Glenum = GL_RGB): TileSetObj =
  ## Creates a new TileSet from image
  var
    surface = image.load(img)  # load image from file
    textureid: Gluint = 0
  if surface.isNil():
    throwError(ResourceError, "image \"" & img & "\" not loaded!")

  glGenTextures(1, textureid.addr)
  glBindTexture(GL_TEXTURE_2D, textureid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

  glTexImage2D(GL_TEXTURE_2D, 0, mode.GLint, surface.w,  surface.h, 0, mode, GL_UNSIGNED_BYTE, surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)

  result = TileSetObj(
    grid: tile_size,
    size: Vector2(surface.w.float, surface.h.float),
    texture: textureid
  )
  surface.freeSurface()


proc draw*(self: TileSetObj, tilex, tiley, x, y, z: float) =
  ## Draws tile at position `tilex`,`tiley` to `x`,`y` position.
  if self.texture > 0:
    let
      texx1 = self.grid.x*tilex / self.size.x
      texy1 = self.grid.y*tiley / self.size.y
      texx2 = self.grid.x*(tilex+1f) / self.size.x
      texy2 = self.grid.y*(tiley+1f) / self.size.y
    glPushMatrix()
    glTranslatef(x, y, z)
    glBindTexture(GL_TEXTURE_2D, self.texture)
    glBegin(GL_QUADS)
    glTexCoord2f(texx1, texy1)
    glVertex3f(0, 0, 0)
    glTexCoord2f(texx1, texy2)
    glVertex3f(0, -self.grid.y, 0)
    glTexCoord2f(texx2, texy2)
    glVertex3f(self.grid.x, -self.grid.y, 0)
    glTexCoord2f(texx2, texy1)
    glVertex3f(self.grid.x, 0, 0)
    glEnd()
    glBindTexture(GL_TEXTURE_2D, 0)
    glPopMatrix()

proc freeMemory*(self: TileSetObj) =
  glDeleteTextures(1, addr self.texture)
