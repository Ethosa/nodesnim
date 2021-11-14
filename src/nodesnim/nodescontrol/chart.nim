# author: Ethosa
## Provides charting functionality
import
  ../thirdparty/opengl,

  ../core/font,
  ../core/enums,
  ../core/color,
  ../core/exceptions,
  ../core/vector2,
  ../core/chartdata,
  ../core/themes,

  ../nodes/node,

  control,
  sequtils


type
  ChartObj* = object of ControlObj
    line_color*: ColorRef
    chart_type*: ChartType
    data*: ChartData
  ChartRef* = ref ChartObj


proc Chart*(name: string = "Chart", chart_type: ChartType = LINE_CHART): ChartRef =
  ## Creates a new Chart object.
  nodepattern(ChartRef)
  controlpattern()
  result.chart_type = chart_type
  result.data = newChartData("some data", current_theme~accent)
  result.line_color = current_theme~foreground


method draw*(self: ChartRef, w, h: GLfloat) =
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    start_x = x + self.rect_size.x/10
    end_y = y - self.rect_size.y + self.rect_size.y/10
    data = zip(self.data.x_axis, self.data.y_axis)
    width = (self.rect_size.x - self.rect_size.x/5) / data.len.float
    max_val = self.data.findMax().y.getNum()

  glColor(self.line_color)
  glLineWidth(2)
  glBegin(GL_LINE_STRIP)
  glVertex2f(start_x, y)
  glVertex2f(start_x, end_y)
  glVertex2f(x + self.rect_size.x - self.rect_size.x/10, end_y)
  glEnd()

  glColor(self.data.data_color)
  for i in data.low..data.high:
    let
      j = i.float
      h = (self.rect_size.y - self.rect_size.y/5) * (data[i][1].getNum() / max_val)
    glRectf(start_x + width*j, end_y + h, start_x + width*(j+1), end_y)

