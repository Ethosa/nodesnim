# author: Ethosa
## Provides charting functionality
import ../thirdparty/sdl2 except Color, glBindTexture
import
  ../thirdparty/gl,

  ../core/anchor,
  ../core/enums,
  ../core/color,
  ../core/vector2,
  ../core/chartdata,
  ../core/themes,
  ../core/font,
  ../private/templates,
  ../graphics/drawable,

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
    self.chartDrawAxis()

  for chart_data in self.data:
    let
      data = zip(chart_data.x_axis, chart_data.y_axis)
      max_height = self.rect_size.y - self.rect_size.y/5
      max_val = chart_data.findMax().y.getNum()
      section_width = (self.rect_size.x - self.rect_size.x/5) / data.len.float

    glColor(chart_data.data_color)
    case chart_data.chart_type
    of LINE_CHART:
      chartDrawLine()
    of BAR_CHART:
      chartDrawBar()
    of PIE_CHART:
      chart_data.chartDrawPie()
    of RADAR_CHART:
      chartDrawRadar()


method addChartData*(self: ChartRef, chart_data: ChartData) {.base.} =
  self.data.add(chart_data)
