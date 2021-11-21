# author: Ethosa
## It provides display sprites.
import
  ../thirdparty/opengl,

  ../core/vector3,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/image,
  ../core/color,

  ../nodes/node,
  node3d


type
  Sprite3DObj* = object of Node3DObj
    filter*: ColorRef
    texture*: GlTextureObj
  Sprite3DRef* = ref Sprite3DObj



proc Sprite3D*(name: string = "Sprite3D"): Sprite3DRef =
  ## Creates a new Sprite3D.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = Sprite3D("Sprite3D")
  nodepattern(Sprite3DRef)
  node3dpattern()
  result.texture = GlTextureObj()
  result.filter = Color(1f, 1f, 1f)
  result.kind = SPRITE_3D_NODE


method draw*(self: Sprite3DRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  # Recalculate position.
  procCall self.Node3DRef.draw(w, h)

  # Draw
  if self.texture.texture > 0'u32:
    let height = (self.texture.size.y/self.texture.size.x).float
    glPushMatrix()
    glTranslatef(self.global_translation.x, self.global_translation.y, self.global_translation.z)
    glRotatef(self.global_rotation.x, 1, 0, 0)
    glRotatef(self.global_rotation.y, 0, 1, 0)
    glRotatef(self.global_rotation.z, 0, 0, 1)
    glScalef(self.scale.x, self.scale.y, self.scale.z)
    glColor(self.filter)

    glEnable(GL_TEXTURE_2D)
    glEnable(GL_DEPTH_TEST)
    glBindTexture(GL_TEXTURE_2D, self.texture.texture)

    glBegin(GL_QUADS)
    glTexCoord2f(0, 0)
    glVertex3f(-1, height, 0)
    glTexCoord2f(0, 1)
    glVertex3f(-1, -height, 0)
    glTexCoord2f(1, 1)
    glVertex3f(1, -height, 0)
    glTexCoord2f(1, 0)
    glVertex3f(1, height, 0)
    glEnd()

    glDisable(GL_DEPTH_TEST)
    glDisable(GL_TEXTURE_2D)
    glPopMatrix()

method duplicate*(self: Sprite3DRef): Sprite3DRef {.base.} =
  ## Duplicates Sprite object and create a new Sprite.
  self.deepCopy()

method loadTexture*(self: Sprite3DRef, file: string, mode = GL_RGB) {.base.} =
  ## Loads a new texture from file.
  ##
  ## Arguments:
  ## - `file` is a texture path.
  ## - `mode` is a GLenum. can be GL_RGB or GL_RGBA.
  if self.texture.texture > 0'u32:
    glDeleteTextures(1, addr self.texture.texture)
  self.texture = load(file, mode)

method setTexture*(self: Sprite3DRef, texture: GlTextureObj) {.base.} =
  ## Loads a new texture from file.
  ##
  ## Arguments:
  ## - `texture` is a GlTexture object.
  if self.texture.texture > 0'u32:
    glDeleteTextures(1, addr self.texture.texture)
  self.texture = texture
