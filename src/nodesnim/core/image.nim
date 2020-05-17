# author: Ethosa
import
  ../thirdparty/opengl,
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/image


discard image.init()


proc load*(file: cstring): Gluint =
  var
    surface = image.load(file)
    textureid: Gluint

  # OpenGL:
  glGenTextures(1, textureid.addr)
  glBindTexture(GL_TEXTURE_2D, textureid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB.GLint, surface.w,  surface.h, 0, GL_RGB, GL_UNSIGNED_BYTE, surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)
  surface.freeSurface()
  return textureid
