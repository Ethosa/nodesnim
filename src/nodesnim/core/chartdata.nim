# author: Ethosa
import
  algorithm,
  sequtils,
  color,
  enums

type
  ChartDataValue* = object
    case kind*: ChartDataValueType
    of INTEGER_VALUE:
      ival*: int
    of FLOAT_VALUE:
      fval*: float
    of STRING_VALUE:
      sval*: string
    of CHAR_VALUE:
      cval*: char

  ChartData* = ref object
    data_color*: ColorRef
    data_name*: string
    x_axis*: seq[ChartDataValue]
    y_axis*: seq[ChartDataValue]


proc newChartData*(data_name: string = "data", data_color: ColorRef = Color()): ChartData =
  ## Creates a new empty ChartData.
  runnableExamples:
    var my_chart_data = newChartData()
  ChartData(x_axis: @[], y_axis: @[], data_name: data_name, data_color: data_color)

proc newChartData*(x_length, y_length: int, data_name: string = "data",
                   data_color: ColorRef = Color()): ChartData =
  ## Creates a new ChartData with specified length.
  ##
  ## Arguments:
  ## - x_length -- length of `x_axis`;
  ## - y_length -- length of `y_axis`.
  runnableExamples:
    var my_chart_data1 = newChartData(5, 5)
  result = newChartData(data_name, data_color)
  result.x_axis.setLen(x_length)
  result.y_axis.setLen(y_length)

proc newChartData*(x_data, y_data: seq[ChartDataValue],
                   data_name: string = "data", data_color: ColorRef = Color()): ChartData =
  ## Creates a new ChartData from specified data.
  ##
  ## Arguments:
  ## - x_data -- specified data for `x_axis`;
  ## - y_data -- specified data for `y_axis`.
  runnableExamples:
    var my_chart_data2 = newChartData(@[1, 5, 2], @["10.10.2021", "10.11.2021", "10.01.2021"])
  ChartData(x_axis: x_data, y_axis: y_data, data_name: data_name, data_color: data_color)


proc cmp(x, y: ChartDataValue): int =
  if x.kind == y.kind:
    case x.kind
    of INTEGER_VALUE:
      return cmp(x.ival, y.ival)
    of FLOAT_VALUE:
      return cmp(x.fval, y.fval)
    of STRING_VALUE:
      return cmp(x.sval, y.sval)
    of CHAR_VALUE:
      return cmp(x.cval, y.cval)
proc findMax*(data: seq[ChartDataValue]): ChartDataValue =
  ## Returns max value from sequence.
  (data.sorted do (x, y: ChartDataValue) -> int: cmp(x, y))[^1]

proc findMax*(chart_data: ChartData): tuple[x, y: ChartDataValue] =
  ## Returns max values from ChartData.
  (x: findMax(chart_data.x_axis), y: findMax(chart_data.y_axis))

proc len*(data: ChartData): int =
  zip(data.x_axis, data.y_axis).len

proc getNum*(val: ChartDataValue): float =
  case val.kind
  of INTEGER_VALUE:
    val.ival.float
  of FLOAT_VALUE:
    val.fval
  of CHAR_VALUE:
    ord(val.cval).float
  of STRING_VALUE:
    0f


converter toChartDataValue*(val: seq[int]): seq[ChartDataValue] =
  result = @[]
  for i in val:
    result.add(ChartDataValue(kind: INTEGER_VALUE, ival: i))
converter toChartDataValue*(val: seq[float]): seq[ChartDataValue] =
  result = @[]
  for i in val:
    result.add(ChartDataValue(kind: FLOAT_VALUE, fval: i))
converter toChartDataValue*(val: seq[string]): seq[ChartDataValue] =
  result = @[]
  for i in val:
    result.add(ChartDataValue(kind: STRING_VALUE, sval: i))
converter toChartDataValue*(val: seq[char]): seq[ChartDataValue] =
  result = @[]
  for i in val:
    result.add(ChartDataValue(kind: CHAR_VALUE, cval: i))
