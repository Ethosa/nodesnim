# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/image,

  vector2

when defined(debug):
  import logging

discard image.init()


type
  GlTextureObj* = object of RootObj
    texture*: Gluint
    size*: Vector2Obj


proc load*(file: cstring, x, y: var float, mode: Glenum = GL_RGB): Gluint =
  ## Loads image from file and returns texture ID.
  ##
  ## Arguments:
  ## - `file` - image path.
  var
    surface = image.load(file)  # load image from file
    textureid: Gluint
  when defined(debug):
    if surface == nil:
      error("image \"", file, "\" not loaded!")
  x = surface.w.float
  y = surface.h.float


  # OpenGL:
  glGenTextures(1, textureid.addr)
  glBindTexture(GL_TEXTURE_2D, textureid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

  glTexImage2D(GL_TEXTURE_2D, 0, mode.GLint, surface.w,  surface.h, 0, mode, GL_UNSIGNED_BYTE, surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)

  # free memory
  surface.freeSurface()
  surface = nil

  textureid


proc load*(file: cstring, mode: Glenum = GL_RGB): GlTextureObj =
  ## Loads GL texture.
  ##
  ## Arguments:
  ## - `file` - image path.
  var
    x: float = 0f
    y: float = 0f
    textureid: Gluint
  textureid = load(file, x, y, mode)
  GlTextureObj(texture: textureid, size: Vector2(x, y))
