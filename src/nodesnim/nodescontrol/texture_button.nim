# author: Ethosa
## It is the convenient alternative of the Button node.
import ../thirdparty/sdl2 except Color
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/image,
  ../core/color,
  ../core/font,

  ../nodes/node,
  control,
  label


type
  TextureButtonTouchHandler* = proc(self: TextureButtonRef, x, y: float)
  TextureButtonObj* = object of LabelObj
    button_mask*: cint  ## Mask for handle clicks
    action_mask*: cint  ## BUTTON_RELEASE or BUTTON_CLICK.

    normal_background_texture*: GlTextureObj  ## texture, when button is not pressed and not hovered.
    hover_background_texture*: GlTextureObj   ## texture, when button hovered.
    press_background_texture*: GlTextureObj   ## texture, when button pressed.

    on_touch*: TextureButtonTouchHandler  ## This called, when user clicks on button.
  TextureButtonRef* = ref TextureButtonObj

let touch_handler = proc(self: TextureButtonRef, x, y: float) = discard


proc TextureButton*(name: string = "TextureButton"): TextureButtonRef =
  ## Creates a new TextureButton node.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var my_button = TextureButton("TextureButton")
  nodepattern(TextureButtonRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.text = stext""
  result.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
  result.button_mask = BUTTON_LEFT.cint
  result.action_mask = BUTTON_RELEASE
  result.normal_background_texture = GlTextureObj()
  result.hover_background_texture = GlTextureObj()
  result.press_background_texture = GlTextureObj()
  result.on_touch = touch_handler
  result.on_text_changed = text_changed_handler
  result.kind = TEXTURE_BUTTON_NODE


method draw*(self: TextureButtonRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    texture =
      if self.pressed and self.focused:
        self.press_background_texture
      elif self.hovered and not mouse_pressed:
        self.hover_background_texture
      else:
        self.normal_background_texture

  # Texture
  if texture.texture > 0'u32:
    glColor4f(0.8, 0.8, 0.8, 1f)
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

  self.text.rendered = false
  procCall self.LabelRef.draw(w, h)

method duplicate*(self: TextureButtonRef): TextureButtonRef {.base.} =
  ## Duplicates TextureButton object and creates a new TextureButton node.
  self.deepCopy()

method handle*(self: TextureButtonRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. This uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if self.hovered and self.focused:
    if event.kind == MOUSE and self.action_mask == 1 and mouse_pressed and self.button_mask == event.button_index:
      self.on_touch(self, event.x, event.y)
    elif event.kind == MOUSE and self.action_mask == 0 and not mouse_pressed and self.button_mask == event.button_index:
      self.on_touch(self, event.x, event.y)

method setNormalTexture*(self: TextureButtonRef, texture: GlTextureObj) {.base.} =
  ## Changes button texture, when it not pressed and not hovered.
  self.normal_background_texture = texture

method setHoverTexture*(self: TextureButtonRef, texture: GlTextureObj) {.base.} =
  ## Changes button texture, when it hovered.
  self.hover_background_texture = texture

method setPressTexture*(self: TextureButtonRef, texture: GlTextureObj) {.base.} =
  ## Changes button texture, when it pressed.
  self.press_background_texture = texture
