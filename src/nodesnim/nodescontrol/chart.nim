# author: Ethosa
## Provides charting functionality
import
  ../thirdparty/opengl,

  ../core/enums,
  ../core/color,
  ../core/vector2,
  ../core/chartdata,
  ../core/themes,

  ../nodes/node,

  control,
  sequtils,
  math


type
  ChartObj* = object of ControlObj
    line_color*: ColorRef
    data*: seq[ChartData]
  ChartRef* = ref ChartObj


proc Chart*(name: string = "Chart"): ChartRef =
  ## Creates a new Chart object.
  nodepattern(ChartRef)
  controlpattern()
  result.data = @[]
  result.line_color = current_theme~foreground
  result.kind = CHART_NODE

method hasAxis*(self: ChartRef): bool {.base.} =
  ## Returns true, if chart contains axis data.
  ## For example: LINE_CHART, BAR_CHART.
  for data in self.data:
    if data.chart_type in [LINE_CHART, BAR_CHART]:
      return true
  false


method draw*(self: ChartRef, w, h: GLfloat) =
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    start_x = x + self.rect_size.x/10
    end_y = y - self.rect_size.y + self.rect_size.y/10

  if self.hasAxis():
    glColor(self.line_color)
    glLineWidth(2)
    glBegin(GL_LINE_STRIP)
    glVertex2f(start_x, y)
    glVertex2f(start_x, end_y)
    glVertex2f(x + self.rect_size.x - self.rect_size.x/10, end_y)
    glEnd()

  for chart_data in self.data:
    let
      data = zip(chart_data.x_axis, chart_data.y_axis)
      max_height = self.rect_size.y - self.rect_size.y/5
      max_val = chart_data.findMax().y.getNum()
      section_width = (self.rect_size.x - self.rect_size.x/5) / data.len.float

    glColor(chart_data.data_color)

    case chart_data.chart_type
    of LINE_CHART:
      glBegin(GL_LINE_STRIP)
      for i in data.low..data.high:
        let
          j = i.float
          h = max_height * (data[i][1].getNum() / max_val)
        glVertex2f(start_x + section_width*j + section_width/2, end_y + h)
      glEnd()

    of BAR_CHART:
      for i in data.low..data.high:
        let
          j = i.float
          h = max_height * (data[i][1].getNum() / max_val)
        glRectf(start_x + section_width*j, end_y + h, start_x + section_width*(j+1), end_y)

    of PIE_CHART:
      let
        d = chart_data.getSorted()
        sum = chart_data.getSum()
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

    of RADAR_CHART:
      let
        radius_max = min(self.rect_size.x, self.rect_size.y)/2
        radius_step = radius_max/5
        center = Vector2(x + self.rect_size.x/2, y - self.rect_size.y/2)
        angle_step = TAU / data.len.float
      var
        radius = radius_step
        angle = 0f
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


method addChartData*(self: ChartRef, chart_data: ChartData) {.base.} =
  self.data.add(chart_data)

