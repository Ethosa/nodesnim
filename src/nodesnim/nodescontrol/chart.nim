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
  sequtils


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


method draw*(self: ChartRef, w, h: GLfloat) =
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    start_x = x + self.rect_size.x/10
    end_y = y - self.rect_size.y + self.rect_size.y/10

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

    glColor(chart_data.data_color)

    case chart_data.chart_type
    of LINE_CHART:
      let section_width = (self.rect_size.x - self.rect_size.x/5) / (data.len.float-1)
      glBegin(GL_LINE_STRIP)
      for i in data.low..data.high:
        let
          j = i.float
          h = max_height * (data[i][1].getNum() / max_val)
        glVertex2f(start_x + section_width*j, end_y + h)
      glEnd()
    of BAR_CHART:
      let section_width = (self.rect_size.x - self.rect_size.x/5) / data.len.float
      for i in data.low..data.high:
        let
          j = i.float
          h = max_height * (data[i][1].getNum() / max_val)
        glRectf(start_x + section_width*j, end_y + h, start_x + section_width*(j+1), end_y)

method addChartData*(self: ChartRef, chart_data: ChartData) {.base.} =
  self.data.add(chart_data)

