# author: Ethosa
## It provides convenient display progress.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/image,
  ../core/enums,

  ../nodes/node,
  control


type
  TextureProgressBarObj* = object of ControlPtr
    max_value*, value*: uint
    progress_texture*, back_texture*: GlTextureObj
  TextureProgressBarPtr* = ptr TextureProgressBarObj


proc TextureProgressBar*(name: string, variable: var TextureProgressBarObj): TextureProgressBarPtr =
  ## Creates a new TextureProgressBar pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a TextureProgressBarObj variable.
  runnableExamples:
    var
      pobj: TextureProgressBarObj
      p = TextureProgressBar("TextureProgressBar", pobj)
  nodepattern(TextureProgressBarObj)
  controlpattern()
  variable.rect_size.x = 120
  variable.rect_size.y = 40
  variable.progress_texture = GlTextureObj()
  variable.back_texture = GlTextureObj()
  variable.max_value = 100
  variable.value = 0
  variable.kind = TEXTURE_PROGRESS_BAR_NODE

proc TextureProgressBar*(obj: var TextureProgressBarObj): TextureProgressBarPtr {.inline.} =
  ## Creates a new TextureProgressBar pointer with default node name "TextureProgressBar".
  ##
  ## Arguments:
  ## - `variable` is a TextureProgressBarObj variable.
  runnableExamples:
    var
      pobj: TextureProgressBarObj
      p = TextureProgressBar(pobj)
  TextureProgressBar("TextureProgressBar", obj)


method draw*(self: TextureProgressBarPtr, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Background
  glColor4f(self.background_color.r, self.background_color.g, self.background_color.b, self.background_color.a)
  glRectf(x, y, x + self.rect_size.x, y - self.rect_size.y)

  # Progress
  let
    texture_w = self.value.float / self.max_value.float
    progress = self.rect_size.x * texture_w
  glColor4f(1f, 1f, 1f, 1f)
  if self.back_texture.texture > 0:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, self.back_texture.texture)

    glBegin(GL_QUADS)
    glTexCoord2f(0, 0)
    glVertex2f(x, y)
    glTexCoord2f(0, 1)
    glVertex2f(x, y - self.rect_size.y)
    glTexCoord2f(1, 1)
    glVertex2f(x + self.rect_size.x, y - self.rect_size.y)
    glTexCoord2f(1, 0)
    glVertex2f(x + self.rect_size.x, y)
    glEnd()

    glDisable(GL_TEXTURE_2D)

  if self.progress_texture.texture > 0:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, self.progress_texture.texture)

    glBegin(GL_QUADS)
    glTexCoord2f(0, 0)
    glVertex2f(x, y)
    glTexCoord2f(0, 1)
    glVertex2f(x, y - self.rect_size.y)
    glTexCoord2f(texture_w, 1)
    glVertex2f(x + progress, y - self.rect_size.y)
    glTexCoord2f(texture_w, 0)
    glVertex2f(x + progress, y)
    glEnd()

    glDisable(GL_TEXTURE_2D)

  # Press
  if self.pressed:
    self.press(last_event.x, last_event.y)

method duplicate*(self: TextureProgressBarPtr, obj: var TextureProgressBarObj): TextureProgressBarPtr {.base.} =
  ## Duplicates TextureProgressBar object and create a new TextureProgressBar pointer.
  obj = self[]
  obj.addr

method setMaxValue*(self: TextureProgressBarPtr, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: TextureProgressBarPtr, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressTexture*(self: TextureProgressBarPtr, texture: GlTextureObj) {.base.} =
  ## Changes progress texture.
  self.progress_texture = texture

method setBackgroundTexture*(self: TextureProgressBarPtr, texture: GlTextureObj) {.base.} =
  ## Changes background progress texture.
  self.back_texture = texture
