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
  ../private/templates,

  ../nodes/node,
  ../graphics/drawable,
  control


type
  TextureProgressBarObj* = object of ControlRef
    max_value*, value*: uint
    progress_texture*, back_texture*: GlTextureObj
  TextureProgressBarRef* = ref TextureProgressBarObj


proc TextureProgressBar*(name: string = "TextureProgressBar"): TextureProgressBarRef =
  ## Creates a new TextureProgressBar.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var p = TextureProgressBar("TextureProgressBar")
  nodepattern(TextureProgressBarRef)
  controlpattern()
  result.rect_size.x = 120
  result.rect_size.y = 40
  result.progress_texture = GlTextureObj()
  result.back_texture = GlTextureObj()
  result.max_value = 100
  result.value = 0
  result.kind = TEXTURE_PROGRESS_BAR_NODE


method draw*(self: TextureProgressBarRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Background
  self.background.draw(x, y, self.rect_size.x, self.rect_size.y)

  # Progress
  let
    texture_w = self.value.float / self.max_value.float
    progress = self.rect_size.x * texture_w
  glColor4f(1f, 1f, 1f, 1f)
  if self.back_texture.texture > 0'u32:
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

    glBindTexture(GL_TEXTURE_2D, 0)
    glDisable(GL_TEXTURE_2D)

  if self.progress_texture.texture > 0'u32:
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

    glBindTexture(GL_TEXTURE_2D, 0)
    glDisable(GL_TEXTURE_2D)

  # Press
  if self.pressed:
    self.on_press(self, last_event.x, last_event.y)

method duplicate*(self: TextureProgressBarRef): TextureProgressBarRef {.base.} =
  ## Duplicates TextureProgressBar object and create a new TextureProgressBar.
  self.deepCopy()

method setMaxValue*(self: TextureProgressBarRef, value: uint) {.base.} =
  ## Changes max value.
  if value > self.value:
    self.max_value = value
  else:
    self.max_value = self.value

method setProgress*(self: TextureProgressBarRef, value: uint) {.base.} =
  ## Changes progress.
  if value > self.max_value:
    self.value = self.max_value
  else:
    self.value = value

method setProgressTexture*(self: TextureProgressBarRef, texture: GlTextureObj) {.base.} =
  ## Changes progress texture.
  if self.progress_texture.texture > 0'u32:
    glDeleteTextures(1, addr self.progress_texture.texture)
  self.progress_texture = texture

method setBackgroundTexture*(self: TextureProgressBarRef, texture: GlTextureObj) {.base.} =
  ## Changes background progress texture.
  if self.back_texture.texture > 0'u32:
    glDeleteTextures(1, addr self.back_texture.texture)
  self.back_texture = texture
