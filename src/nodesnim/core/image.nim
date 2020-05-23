# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/image,

  ../core/vector2


discard image.init()


type
  GlTexture* = object
    texture*: Gluint
    size*: Vector2Ref


proc load*(file: cstring, size: var Vector2Ref): Gluint =
  ## Loads image from file and returns texture ID.
  ##
  ## Arguments:
  ## - `file` - image path.
  var
    surface = image.load(file)  # load image from file
    textureid: Gluint
  size.x = surface.w.float
  size.y = surface.h.float

  # OpenGL:
  glGenTextures(1, textureid.addr)
  glBindTexture(GL_TEXTURE_2D, textureid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB.GLint, surface.w,  surface.h, 0, GL_RGB, GL_UNSIGNED_BYTE, surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)

  # free memory
  surface.freeSurface()
  surface = nil

  textureid


proc load*(file: cstring): GlTexture =
  ## Loads GL texture.
  ##
  ## Arguments:
  ## - `file` - image path.
  var
    size: Vector2Ref = Vector2Ref()
    textureid: Gluint
  textureid = load(file, size)
  GlTexture(texture: textureid, size: size)
