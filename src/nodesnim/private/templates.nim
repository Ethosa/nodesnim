# author: Ethosa

template voidTemplate* = discard


# ----- Core templates ----- #
template loadGLSLShader*(shader, shader_source: untyped) =
  var source = allocCStringArray([`shader_source`])
  glShaderSource(`shader`, 1, source, addr success)
  glCompileShader(`shader`)
  glGetShaderiv(`shader`, GL_COMPILE_STATUS, addr success)
  if success == 0:
    glGetShaderInfoLog(`shader`, 512, addr success, infoLog)
    throwError(ShaderCompileError, $infoLog)
  deallocCStringArray(source)



# ----- Graphics templates ----- #

template calculateDrawableCorners*(shadow: bool = false) =
  ## Calculates vertex positions.
  let (xw, yh) = (x + width, y - height)
  when not shadow:
    # left top
    for i in bezier_iter(1f/self.border_detail[0].float, Vector2(0, -self.border_radius[0]),
                         Vector2(0, 0), Vector2(self.border_radius[0], 0)):
      vertex.add(Vector2(x + i.x, y + i.y))

    # right top
    for i in bezier_iter(1f/self.border_detail[1].float, Vector2(-self.border_radius[01], 0),
                         Vector2(0, 0), Vector2(0, -self.border_radius[1])):
      vertex.add(Vector2(xw + i.x, y + i.y))

    # right bottom
    for i in bezier_iter(1f/self.border_detail[2].float, Vector2(0, -self.border_radius[2]),
                         Vector2(0, 0), Vector2(-self.border_radius[2], 0)):
      vertex.add(Vector2(xw + i.x, yh - i.y))

    # left bottom
    for i in bezier_iter(1f/self.border_detail[3].float, Vector2(self.border_radius[3], 0),
                         Vector2(0, 0), Vector2(0, self.border_radius[3])):
      vertex.add(Vector2(x + i.x, yh + i.y))
  else:
    glBegin(GL_QUAD_STRIP)
    # left top
    for i in bezier_iter(1f/self.border_detail[0].float, Vector2(0, -self.border_radius[0]),
                         Vector2(0, 0), Vector2(self.border_radius[0], 0)):
      glColor4f(0, 0, 0, 0)
      glVertex2f(x + i.x + self.shadow_offset.x, y + i.y - self.shadow_offset.y)
      glColor(self.shadow_color)
      glVertex2f(x + i.x, y + i.y)

    # right top
    for i in bezier_iter(1f/self.border_detail[1].float, Vector2(-self.border_radius[1], 0),
                         Vector2(0, 0), Vector2(0, -self.border_radius[1])):
      glColor4f(0, 0, 0, 0)
      glVertex2f(xw + i.x + self.shadow_offset.x, y + i.y - self.shadow_offset.y)
      glColor(self.shadow_color)
      glVertex2f(xw + i.x, y + i.y)

    # right bottom
    for i in bezier_iter(1f/self.border_detail[2].float, Vector2(0, -self.border_radius[2]),
                         Vector2(0, 0), Vector2(-self.border_radius[2], 0)):
      glColor4f(0, 0, 0, 0)
      glVertex2f(xw + i.x + self.shadow_offset.x, yh - i.y - self.shadow_offset.y)
      glColor(self.shadow_color)
      glVertex2f(xw + i.x, yh - i.y)

    # left bottom
    for i in bezier_iter(1f/self.border_detail[3].float, Vector2(self.border_radius[3], 0),
                         Vector2(0, 0), Vector2(0, self.border_radius[3])):
      glColor4f(0, 0, 0, 0)
      glVertex2f(x + i.x + self.shadow_offset.x, yh + i.y - self.shadow_offset.y)
      glColor(self.shadow_color)
      glVertex2f(x + i.x, yh + i.y)

    glColor4f(0, 0, 0, 0)
    glVertex2f(x + self.shadow_offset.x, y - self.border_radius[0] - self.shadow_offset.y)
    glColor(self.shadow_color)
    glVertex2f(x, y - self.border_radius[0])
    glEnd()


template drawTemplate*(drawtype, color, function, secondfunc: untyped): untyped =
  ## Draws colorized vertexes
  ##
  ## Arguments:
  ## - `drawtype` - draw type, like `GL_POLYGON`
  ## - `color` - color for border drawing.
  ## - `function` - function called before `glBegin`
  ## - `secondfunc` - function called after `glEnd`
  glColor4f(`color`.r, `color`.g, `color`.b, `color`.a)
  `function`
  glBegin(`drawtype`)

  for i in vertex:
    glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`


template drawTemplate*(drawtype, color, function, secondfunc: untyped, is_gradient: bool): untyped =
  ## Draws colorized vertexes
  ##
  ## Arguments:
  ## - `drawtype` - draw type, like `GL_POLYGON`
  ## - `color` - color for border drawing.
  ## - `function` - function called before `glBegin`
  ## - `secondfunc` - function called after `glEnd`
  ## - `is_gradient` - true when drawtype is `GL_POLYGON`.
  glColor4f(`color`.r, `color`.g, `color`.b, `color`.a)
  `function`
  glBegin(`drawtype`)

  if is_gradient:
    for i in 0..vertex.high:
      let tmp = i/vertex.len()
      if tmp < 0.25:
        glColor(self.corners[0])
      elif tmp < 0.5:
        glColor(self.corners[1])
      elif tmp < 0.75:
        glColor(self.corners[2])
      else:
        glColor(self.corners[3])
      glVertex2f(vertex[i].x, vertex[i].y)
  else:
    for i in vertex:
      glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`

template drawTextureTemplate*(drawtype, color, function, secondfunc: untyped): untyped =
  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, self.texture.texture)
  glColor4f(`color`.r, `color`.g, `color`.b, `color`.a)
  `function`
  glBegin(`drawtype`)
  var
    texture_size = self.texture.size
    h = height
    w = width
  if texture_size.x < width:
    let q = width / texture_size.x
    texture_size.x *= q
    texture_size.y *= q

  if texture_size.y < height:
    let q = height / texture_size.y
    texture_size.x *= q
    texture_size.y *= q

  # crop .. :eyes:
  let q = width / texture_size.x
  texture_size.x *= q
  texture_size.y *= q
  h /= height/width

  for i in vertex:
    glTexCoord2f((-x + i.x - w + texture_size.x) / texture_size.x,
                 (y - i.y - h + texture_size.y) / texture_size.y)
    glVertex2f(i.x, i.y)

  glEnd()
  `secondfunc`
  glDisable(GL_TEXTURE_2D)



# ----- Objects templates ----- #

template drawablepattern*(`type`: untyped): untyped =
  result = `type`(
    texture: GlTextureObj(), border_width: 0,
    border_detail: [8, 8, 8, 8],
    border_radius: [0.float, 0, 0, 0],
    border_color: Color(0, 0, 0, 0),
    background_color: Color(0, 0, 0, 0),
    shadow_offset: Vector2(0, 0), shadow: false,
    shadow_color: standard_shadow_color
  )

template nodepattern*(nodetype: untyped): untyped =
  ## This used in childs of the NodeObj.
  result = `nodetype`(
    name: name, children: @[],
    on_ready: handler_default,
    on_process: handler_default,
    on_input: event_handler_default,
    on_enter: handler_default,
    on_exit: handler_default,
    on_theme_changed: handler_default,
    is_ready: false, pausemode: INHERIT, visibility: VISIBLE
  )
  result.type_of_node = NODE_TYPE_DEFAULT

template node2dpattern*: untyped =
  result.centered = false
  result.timed_position = Vector2()
  result.rect_size = Vector2()
  result.rect_min_size = Vector2()
  result.position = Vector2()
  result.global_position = Vector2()
  result.anchor = Anchor(0, 0, 0, 0)
  result.size_anchor = Vector2()
  result.z_index = 0f
  result.z_index_global = 0f
  result.relative_z_index = true
  result.type_of_node = NODE_TYPE_2D

template node3dpattern* =
  result.rotation = Vector3()
  result.translation = Vector3()
  result.scale = Vector3(1, 1, 1)
  result.global_rotation = Vector3()
  result.global_translation = Vector3()
  result.global_scale = Vector3(1, 1, 1)
  result.type_of_node = NODE_TYPE_3D

template controlpattern*: untyped =
  result.hovered = false
  result.focused = false
  result.pressed = false

  result.mousemode = MOUSEMODE_SEE
  result.rect_size = Vector2()
  result.rect_min_size = Vector2()
  result.position = Vector2()
  result.global_position = Vector2()
  result.size_anchor = Vector2()
  result.anchor = Anchor(0, 0, 0, 0)
  result.padding = Anchor(0, 0, 0, 0)
  result.background = Drawable()

  result.on_mouse_enter = control_xy_handler
  result.on_mouse_exit = control_xy_handler
  result.on_click = control_xy_handler
  result.on_press = control_xy_handler
  result.on_release = control_xy_handler
  result.on_focus = control_handler
  result.on_unfocus = control_handler
  result.type_of_node = NODE_TYPE_CONTROL



# ----- GUI templates ----- #
template chartDrawAxis*(self: untyped) =
  glColor(`self`.line_color)
  glLineWidth(2)
  glBegin(GL_LINE_STRIP)
  glVertex2f(start_x, y)
  glVertex2f(start_x, end_y)
  glVertex2f(x + `self`.rect_size.x - `self`.rect_size.x/10, end_y)
  glEnd()


template chartDrawRadar* =
  let
   value_step = max_val / 5
   radius_max = min(self.rect_size.x, self.rect_size.y)/2
   radius_step = radius_max/5
   center = Vector2(x + self.rect_size.x/2, y - self.rect_size.y/2)
   angle_step = TAU / data.len.float
  var
    radius = radius_step
    angle = 0f
    val = value_step
  glColor(current_theme~foreground)
  glLineWidth(1)
  for step in 0..5:
    glBegin(GL_LINE_LOOP)
    for i in data.low..data.high:
      glVertex2f(center.x + cos(angle)*radius, center.y + sin(angle)*radius)
      angle += angle_step
    radius += radius_step
    angle = 0f
    glEnd()

  glBegin(GL_LINES)
  for i in data.low..data.high:
    glVertex2f(center.x + cos(angle)*radius_max, center.y + sin(angle)*radius_max)
    glVertex2f(center.x, center.y)
    angle += angle_step
  angle = 0f
  glEnd()

  glColor4f(chart_data.data_color.r, chart_data.data_color.g, chart_data.data_color.b, 0.8)
  glBegin(GL_POLYGON)
  for i in data.low..data.high:
    let r = radius_max * (data[i][1].getNum() / max_val)
    glVertex2f(center.x + cos(angle)*r, center.y + sin(angle)*r)
    angle += angle_step
  glEnd()

  angle = 0f
  for i in data.low..data.high:
    let
      text = stext($data[i][0])
      size = text.getTextSize()
    text.renderTo(
      Vector2(center.x + cos(angle)*(radius_max+radius_step) - size.x/2,
              center.y + sin(angle)*(radius_max+radius_step) + size.y),
      size, Anchor())
    angle += angle_step
    text.freeMemory()

  radius = radius_step
  for step in 0..5:
    let
      text = stext($val, current_theme~foreground)
      size = text.getTextSize()
    text.setBold(true)
    text.renderTo(Vector2(center.x - size.x, center.y + radius+radius_step/2), size, Anchor())
    radius += radius_step
    val += value_step
    text.freeMemory()


template chartDrawLine* =
  glBegin(GL_LINE_STRIP)
  for i in data.low..data.high:
    let
      j = i.float
      h = max_height * (data[i][1].getNum() / max_val)
    glVertex2f(start_x + section_width*j + section_width/2, end_y + h)
  glEnd()


template chartDrawBar* =
  let
    height_step = max_height / 5
    value_step = max_val / 5
  var
    height = height_step
    value = value_step
  for i in data.low..data.high:
    let
      j = i.float
      h = max_height * (data[i][1].getNum() / max_val)
    glColor(chart_data.data_color)
    glRectf(start_x + section_width*j, end_y + h, start_x + section_width*(j+1), end_y)

    let
      text = stext($data[i][0])
      value_text = stext($value)
      size = text.getTextSize()
      value_size = value_text.getTextSize()
    text.renderTo(Vector2(start_x+section_width*j, end_y), size, Anchor())
    value_text.renderTo(Vector2(start_x - value_size.x - 2, end_y + height), size, Anchor())
    height += height_step
    value += value_step
    text.freeMemory()
    value_text.freeMemory()


template chartDrawPie*(chart_data: untyped) =
  let
    d = `chart_data`.getSorted()
    sum = `chart_data`.getSum()
    radius = min(self.rect_size.x, self.rect_size.y)/2
    center = Vector2(x + self.rect_size.x/2, y - self.rect_size.y/2)
  var
    angle = PI/2
    a: float
  for i in d.low..d.high:
    glBegin(GL_TRIANGLE_FAN)
    glVertex2f(center.x, center.y)
    a = angle
    angle += d[i][1].getNum() / sum * TAU
    while a <= angle:
      glVertex2f(center.x + cos(a)*radius, center.y + sin(a)*radius)
      a += 0.01
    glEnd()
    glColor4f(angle/6, angle/5, angle/4, 1f)

template setTextTemplate*(self, `text`, `save_properties`, t: untyped): untyped =
  ## Template for methods like `Label.setText`.
  ##
  ## Arguments:
  ## - `self` - NodeRef;
  ## - `text` - new text;
  ## - `save_properties` - save style;
  ## - `t` - StyleText field name;
  var st = stext(`text`)
  if `self`.`t`.font.isNil():
    `self`.`t`.font = standard_font
  st.font = `self`.`t`.font

  if `save_properties`:
    for i in 0..<st.chars.len():
      if i < `self`.`t`.len():
        st.chars[i].color = `self`.`t`.chars[i].color
        st.chars[i].style = `self`.`t`.chars[i].style
  `self`.`t` = st
  `self`.rect_min_size = `self`.`t`.getTextSize()
  `self`.resize(`self`.rect_size.x, `self`.rect_size.y)
  `self`.`t`.rendered = false
  `self`.on_text_changed(`self`, `text`)



# ----- Canvas templates ----- #
template colorToRenderer*(color_argument_name: untyped): untyped =
  ## Translates `ColorRef` object to uint32 tuple and
  ## changes renderer draw color.
  ##
  ## Arguments:
  ## - color_argument_name` - ColorRef variable.
  let clr = toUint32Tuple(`color_argument_name`)
  canvas.renderer.setDrawColor(clr.r.uint8, clr.g.uint8, clr.b.uint8, clr.a.uint8)

template canvasDrawGL*(canvas: untyped): untyped =
  ## Translates canvas surface to OpenGL texture.
  if `canvas`.canvas_texture == 0:
    glGenTextures(1, `canvas`.canvas_texture.addr)
  glBindTexture(GL_TEXTURE_2D, `canvas`.canvas_texture)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE.GLint)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA.GLint, `canvas`.surface.w,  `canvas`.surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, `canvas`.surface.pixels)
  glBindTexture(GL_TEXTURE_2D, 0)



# ----- Window ----- #
template checkWindowCallback*(event, condition, conditionelif: untyped): untyped =
  if last_event is `event` and `condition`:
    press_state = 2
  elif `conditionelif`:
    press_state = 1
  else:
    press_state = 0
