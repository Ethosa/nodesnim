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
  ../core/themes,

  ../graphics/drawable,

  ../nodes/node,
  ../nodes/canvas,
  browsers,
  control


type
  TextChangedHandler* = proc(self: LabelRef, text: string)
  LabelObj* = object of ControlRef
    on_text_changed*: TextChangedHandler
    text_align*: AnchorObj
    text*: StyleText
  LabelRef* = ref LabelObj

let text_changed_handler* = proc(self: LabelRef, text: string) = discard


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
  result.on_text_changed = text_changed_handler
  result.kind = LABEL_NODE


method draw*(self: LabelRef, w, h: GLfloat) =
  ## This uses in the `window.nim`.
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  if theme_changed:
    self.text.rendered = false
  self.text.renderTo(Vector2(x + self.padding.x1, y - self.padding.y1), self.rect_size, self.text_align)

method duplicate*(self: LabelRef): LabelRef {.base.} =
  ## Duplicates Label object and create a new Label.
  self.deepCopy()

method getText*(self: LabelRef): string {.base.} =
  ## Returns `StyleText` as `string`.
  ##
  ## See also:
  ## * `setText method <#setText.e,LabelRef,string,bool>`_
  $self.text

method handle*(self: LabelRef, event: InputEvent, mouse_on: var NodeRef) =
  ## Handles user input. Thi uses in the `window.nim`.
  procCall self.ControlRef.handle(event, mouse_on)

  if event.kind in [MOUSE, MOTION]:
    let (c, pos) = self.text.getCharUnderPoint(
      self.getGlobalMousePosition(), self.global_position + self.rect_size/2 - self.text.getTextSize()/2,
      self.text_align)

    if not c.isNil() and c.is_url:
      var (i, j) = (pos.int, pos.int)
      while i - 1 > 0 and self.text.chars[i - 1].is_url:
        dec i
      while j + 1 < self.text.len and self.text.chars[j + 1].is_url:
        inc j
      self.text.setUnderline(i, j, true)
      self.text.rendered = false
      if last_event.pressed and last_event.kind == MOUSE:
        openDefaultBrowser(c.url)
    else:
      for i in self.text.chars:
        if i.is_url:
          i.setUnderline(false)
      self.text.rendered = false

method setText*(self: LabelRef, text: string, save_properties: bool = false) {.base.} =
  ## Changes text.
  ##
  ## Arguments:
  ## - `text` is a new Label text.
  ## - `save_properties` - saves old text properties, if `true`.
  ##
  ## See also:
  ## * `getText method <#getText.e,LabelRef>`_
  var st = stext(text)
  if self.text.font.isNil():
    self.text.font = standard_font
  st.font = self.text.font

  if save_properties:
    for i in 0..<st.chars.len():
      if i < self.text.len():
        st.chars[i].color = self.text.chars[i].color
        st.chars[i].style = self.text.chars[i].style
  self.text = st
  self.rect_min_size = self.text.getTextSize()
  self.resize(self.rect_size.x, self.rect_size.y, true)
  self.text.rendered = false
  self.on_text_changed(self, text)

method setTextAlign*(self: LabelRef, x1, y1, x2, y2: float) {.base.} =
  ## Changes text alignment.
  ##
  ## Arguments:
  ## - `x1` `y1` - parent anchor.
  ## - `x2` `y2` - self anchor.
  ##
  ## See also:
  ## * `setTextAlign method <#setTextAlign.e,LabelRef,AnchorObj>`_
  self.text_align = Anchor(x1, y1, x2, y2)
  self.text.rendered = false

method setTextAlign*(self: LabelRef, align: AnchorObj) {.base.} =
  ## Changes text alignment.
  ##
  ## See also:
  ## * `setTextAlign method <#setTextAlign.e,LabelRef,float,float,float,float>`_
  self.text_align = align
  self.text.rendered = false

method setTextColor*(self: LabelRef, color: ColorRef) {.base.} =
  ## Changes text color.
  ##
  ## Arguments:
  ## - `color` - new text color.
  self.text.setColor(color)
  self.text.rendered = false

method setTextFont*(self: LabelRef, font: FontPtr) {.base.} =
  ## Changes text font.
  ##
  ## Arguments:
  ## - `font` - new text font.
  self.text.font = font
  self.text.rendered = false

method setStyle*(self: LabelRef, s: StyleSheetRef) =
  ## Changes Label stylesheet.
  ##
  ## Styles:
  ## - `text-align` - text alignment. `0.5`; `1 0 1 0`.
  ## - `color` - text color. `#ffef`; `rgba(1, 1, 1, 1)`; `rgb(1, 1, 1)`.
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
