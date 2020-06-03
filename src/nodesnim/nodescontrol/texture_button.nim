# author: Ethosa
## It is the convenient alternative of the Button node.
import
  ../thirdparty/opengl,
  ../thirdparty/opengl/glut,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/image,
  ../core/color,

  ../nodes/node,
  control,
  label


type
  TextureButtonObj* = object of LabelObj
    button_mask*: cint  ## Mask for handle clicks
    action_mask*: cint  ## BUTTON_RELEASE or BUTTON_CLICK.

    normal_background_texture*: GlTextureObj  ## texture, when button is not pressed and not hovered.
    hover_background_texture*: GlTextureObj   ## texture, when button hovered.
    press_background_texture*: GlTextureObj   ## texture, when button pressed.

    normal_color*: ColorRef  ## text color, whenwhen button is not pressed and not hovered.
    hover_color*: ColorRef   ## text color, when button hovered.
    press_color*: ColorRef   ## text color, when button pressed.

    on_touch*: proc(self: TextureButtonPtr, x, y: float): void  ## This called, when user clicks on button.
  TextureButtonPtr* = ptr TextureButtonObj


proc TextureButton*(name: string, variable: var TextureButtonObj): TextureButtonPtr =
  ## Creates a new TextureButton node pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a TextureButtonObj variable.
  runnableExamples:
    var
      my_button_obj: TextureButtonObj
      my_button = TextureButton("TextureButton", my_button_obj)
  nodepattern(TextureButtonObj)
  controlpattern()
  variable.rect_size.x = 40
  variable.rect_size.y = 40
  variable.text = ""
  variable.font = GLUT_BITMAP_HELVETICA_12
  variable.size = 12
  variable.spacing = 2
  variable.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
  variable.color = Color(1f, 1f, 1f)
  variable.normal_color = Color(1f, 1f, 1f)
  variable.hover_color = Color(1f, 1f, 1f)
  variable.press_color = Color(1f, 1f, 1f)
  variable.button_mask = BUTTON_LEFT
  variable.action_mask = BUTTON_RELEASE
  variable.normal_background_texture = GlTextureObj()
  variable.hover_background_texture = GlTextureObj()
  variable.press_background_texture = GlTextureObj()
  variable.on_touch = proc(self: TextureButtonPtr, x, y: float) = discard
  variable.kind = TEXTURE_BUTTON_NODE

proc TextureButton*(obj: var TextureButtonObj): TextureButtonPtr {.inline.} =
  ## Creates a new TextureButton node pointer with default node name "TextureButton".
  ##
  ## Arguments:
  ## - `variable` is a TextureButtonObj variable.
  runnableExamples:
    var
      my_button_obj: TextureButtonObj
      my_button = TextureButton(my_button_obj)
  TextureButton("TextureButton", obj)


method draw*(self: TextureButtonPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    texture =
      if self.pressed:
        self.press_background_texture
      elif self.hovered:
        self.hover_background_texture
      else:
        self.normal_background_texture
  self.color =
    if self.pressed:
      self.press_color
    elif self.hovered:
      self.hover_color
    else:
      self.normal_color

  # Texture
  if texture.texture > 0:
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, texture.texture)

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

  procCall self.LabelPtr.draw(w, h)

method duplicate*(self: TextureButtonPtr, obj: var TextureButtonObj): TextureButtonPtr {.base.} =
  ## Duplicates TextureButton object and creates a new TextureButton node pointer.
  obj = self[]
  obj.addr

method handle*(self: TextureButtonPtr, event: InputEvent, mouse_on: var NodePtr) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlPtr.handle(event, mouse_on)

  if self.hovered:
    if event.kind == MOUSE and self.action_mask == 1 and mouse_pressed and self.button_mask == event.button_index:
      self.on_touch(self, event.x, event.y)
    elif event.kind == MOUSE and self.action_mask == 0 and not mouse_pressed and self.button_mask == event.button_index:
      self.on_touch(self, event.x, event.y)

method setNormalTexture*(self: TextureButtonPtr, texture: GlTextureObj) {.base.} =
  ## Changes button texture, when it not pressed and not hovered.
  self.normal_background_texture = texture

method setHoverTexture*(self: TextureButtonPtr, texture: GlTextureObj) {.base.} =
  ## Changes button texture, when it hovered.
  self.hover_background_texture = texture

method setPressTexture*(self: TextureButtonPtr, texture: GlTextureObj) {.base.} =
  ## Changes button texture, when it pressed.
  self.press_background_texture = texture
