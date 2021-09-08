# author: Ethosa
## It provides primitive text rendering.
import
  strutils,
  ../thirdparty/opengl,
  ../thirdparty/sdl2/ttf,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/color,
  ../core/stylesheet,
  ../core/font,
  ../core/nodes_os,

  ../graphics/drawable,

  ../nodes/node,
  ../nodes/canvas,
  control


type
  LabelObj* = object of ControlRef
    text_align*: AnchorRef
    text*: StyleText
  LabelRef* = ref LabelObj


proc Label*(name: string = "Label"): LabelRef =
  ## Creates a new Label.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var text = Label("Label")
  nodepattern(LabelRef)
  controlpattern()
  result.rect_size.x = 40
  result.rect_size.y = 40
  result.text = stext""
  result.text_align = Anchor(0, 0, 0, 0)
  result.kind = LABEL_NODE


method draw*(self: LabelRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  if not self.text.rendered:
    self.text.render(self.rect_size, self.text_align)
  self.text.renderTo(Vector2(x, y), self.rect_size, self.text_align)

method duplicate*(self: LabelRef): LabelRef {.base.} =
  ## Duplicates Label object and create a new Label.
  self.deepCopy()

method getText*(self: LabelRef): string {.base.} =
  $self.text

method setText*(self: LabelRef, text: string, save_properties: bool = false) {.base.} =
  ## Changes text.
  ##
  ## Arguments:
  ## - `text` is a new Label text.
  ## - `save_properties` - saves old text properties, if `true`.
  var st = stext(text)
  if self.text.font.isNil():
    self.text.font = standard_font
  st.font = self.text.font

  if save_properties:
    for i in 0..<st.chars.len():
      if i < self.text.len():
        st.chars[i].color = self.text.chars[i].color
        st.chars[i].underline = self.text.chars[i].underline
  self.text = st
  self.rect_min_size = self.text.getTextSize()
  self.resize(self.rect_size.x, self.rect_size.y, true)
  self.text.rendered = false

method setTextAlign*(self: LabelRef, x1, y1, x2, y2: float) {.base.} =
  self.text_align = Anchor(x1, y1, x2, y2)
  self.text.rendered = false

method setTextAlign*(self: LabelRef, align: AnchorRef) {.base.} =
  self.text_align = align
  self.text.rendered = false

method setTextColor*(self: LabelRef, color: ColorRef) {.base.} =
  self.text.setColor(color)
  self.text.rendered = false

method setTextFont*(self: LabelRef, font: FontPtr) {.base.} =
  self.text.font = font
  self.text.rendered = false

method setStyle*(self: LabelRef, s: StyleSheetRef) =
  procCall self.ControlRef.setStyle(s)
  self.text.rendered = false

  for i in s.dict:
    case i.key
    # text-align: 0.5
    # text-align: 0.5 0 0.5 0
    of "text-align":
      let tmp = i.value.split(Whitespace)
      if tmp.len() == 1:
        if tmp[0] == "center":
          self.setTextAlign(0.5, 0.5, 0.5, 0.5)
        elif tmp[0] == "left":
          self.setTextAlign(0, 0.5, 0, 0.5)
        elif tmp[0] == "right":
          self.setTextAlign(1, 0.5, 1, 0.5)
        elif tmp[0] == "top":
          self.setTextAlign(0.5, 0, 0.5, 0)
        elif tmp[0] == "bottom":
          self.setTextAlign(0.5, 1, 0.5, 1)
        else:
          let tmp2 = parseFloat(tmp[0])
          self.setTextAlign(Anchor(tmp2, tmp2, tmp2, tmp2))
      elif tmp.len() == 4:
        self.setTextAlign(Anchor(
          parseFloat(tmp[0]), parseFloat(tmp[1]),
          parseFloat(tmp[2]), parseFloat(tmp[3]))
        )
    # color: #f6f
    of "color":
      var clr = Color(i.value)
      if not clr.isNil():
        self.setTextColor(clr)
    else:
      discard
