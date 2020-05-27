# author: Ethosa
## It provides display sprites.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/image,
  ../core/color,

  ../nodes/node,
  node2d


type
  SpriteObj* = object of Node2DObj
    filter*: ColorRef
    texture*: GlTextureObj
  SpritePtr* = ptr SpriteObj



proc Sprite*(name: string, variable: var SpriteObj): SpritePtr =
  ## Creates a new Sprite pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a SpriteObj variable.
  runnableExamples:
    var
      node_obj: SpriteObj
      node = Sprite("Sprite", node_obj)
  nodepattern(SpriteObj)
  node2dpattern()
  variable.texture = GlTextureObj()
  variable.filter = Color(1f, 1f, 1f)

proc Sprite*(obj: var SpriteObj): SpritePtr {.inline.} =
  ## Creates a new Sprite pointer with deffault node name "Sprite".
  ##
  ## Arguments:
  ## - `variable` is a SpriteObj variable.
  runnableExamples:
    var
      node_obj: SpriteObj
      node = Sprite(node_obj)
  Sprite("Sprite", obj)

method draw*(self: SpritePtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  if self.texture.texture > 0:
    self.rect_size = self.texture.size

  # Recalculate position.
  self.position = self.timed_position
  if self.centered:
    self.position = self.timed_position - self.rect_size/2
  else:
    self.position = self.timed_position

  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Draw
  if self.texture.texture > 0:
    glColor4f(self.filter.r, self.filter.g, self.filter.b, self.filter.a)

    glEnable(GL_TEXTURE_2D)
    glEnable(GL_DEPTH_TEST)
    glBindTexture(GL_TEXTURE_2D, self.texture.texture)

    glBegin(GL_QUADS)
    glTexCoord2f(0, 0)
    glVertex3f(x, y, self.z_index_global)
    glTexCoord2f(0, 1)
    glVertex3f(x, y - self.rect_size.y, self.z_index_global)
    glTexCoord2f(1, 1)
    glVertex3f(x + self.rect_size.x, y - self.rect_size.y, self.z_index_global)
    glTexCoord2f(1, 0)
    glVertex3f(x + self.rect_size.x, y, self.z_index_global)
    glEnd()
    glDisable(GL_DEPTH_TEST)
    glDisable(GL_TEXTURE_2D)
  else:
    self.rect_size = Vector2()

method duplicate*(self: SpritePtr, obj: var SpriteObj): SpritePtr {.base.} =
  ## Duplicates Sprite object and create a new Sprite pointer.
  obj = self[]
  obj.addr

method getGlobalMousePosition*(self: SpritePtr): Vector2Ref {.inline.} =
  ## Returns mouse position.
  Vector2Ref(x: last_event.x, y: last_event.y)

method loadTexture*(self: SpritePtr, file: cstring, mode = GL_RGB) {.base.} =
  ## Loads a new texture from file.
  ##
  ## Arguments:
  ## - `file` is a texture path.
  ## - `mode` is a GLenum. can be GL_RGB or GL_RGBA.
  self.texture = load(file, mode)

method setTexture*(self: SpritePtr, texture: GlTextureObj) {.base.} =
  ## Loads a new texture from file.
  ##
  ## Arguments:
  ## - `texture` is a GlTexture object.
  self.texture = texture
