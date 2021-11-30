# --- Material UI calculator --- #
import
  strutils,
  nodesnim


type
  TokenType {.size: sizeof(int8).} = enum
    NUMBER,
    OPERATOR,
    RPAR,
    LPAR
  Token = ref object
    token_type: TokenType
    token_value: string
  TokenTree = seq[Token]

proc parseQuery(query: string): TokenTree =
  result = @[]
  for c in query:
    if c.isDigit() or c == '.':
      if result.len > 0 and not result[^1].isNil() and result[^1].token_type == NUMBER:
        result[^1].token_value &= $c
      else:
        result.add(Token(token_type: NUMBER, token_value: $c))
    elif c in "+-/*":
      result.add(Token(token_type: OPERATOR, token_value: $c))
  when false:
    for i in result:
      echo i.token_value

proc findHigh(tree: TokenTree): int =
  result = -1
  let tokens = "/*-+"
  for token in tokens:
    for i in tree.low..tree.high:
      if tree[i].token_type == OPERATOR and tree[i].token_value == $token:
        return i-1


proc calculate(tree: TokenTree): float =
  result = 0f

  var
    t = tree
    index = t.findHigh()

  while index != -1:
    case t[index+1].token_value
    of "/":
      t[index].token_value = $(t[index].token_value.parseFloat() / t[index+2].token_value.parseFloat())
    of "*":
      t[index].token_value = $(t[index].token_value.parseFloat() * t[index+2].token_value.parseFloat())
    of "-":
      t[index].token_value = $(t[index].token_value.parseFloat() - t[index+2].token_value.parseFloat())
    of "+":
      t[index].token_value = $(t[index].token_value.parseFloat() + t[index+2].token_value.parseFloat())
    t.del(index+2)
    t.del(index+1)
    index = t.findHigh()
  if t.len == 1:
    result = parseFloat(t[0].token_value)

Window("material ui calculator", ((64+32)*4)+16, 480)
env.background_color = Color("#FAFAFA")


var
  query: string = ""
  big_font = loadFont(standard_font_path, 32)
  medium = loadFont(standard_font_path, 24)
  small = loadFont(standard_font_path, 16)

build:
  - Button number_button:
    call:
      setStyle(style({color: "#EEEEEE"}))
      resize(64+32, 64)
      setTextFont(loadFont(standard_font_path, 24))
  - Button operator_button:
    call:
      setStyle(style({color: "#F5F5F5"}))
      resize(64+32, 51.2f)
      setTextFont(loadFont(standard_font_path, 22))

number_button.normal_background.setStyle(style({background-color: "#424242"}))
number_button.hover_background.setStyle(style({background-color: "#616161"}))
number_button.press_background.setStyle(style({background-color: "#757575"}))

operator_button.normal_background.setStyle(style({background-color: "#616161"}))
operator_button.hover_background.setStyle(style({background-color: "#757575"}))
operator_button.press_background.setStyle(style({background-color: "#9E9E9E"}))


when false:
  query = "123+1*5-200/10"
  var
    parsed = parseQuery(query)
    calculated = calculate(parsed)


build:
  - Scene main:
    - HBox hbox:
      separator: 0
      call:
        setPadding(8, 8, 8, 8)
        move(0, 200)
      - GridBox numbers:
        separator: 0
        call setRow(3)
      - Vbox operators:
        separator: 0
    - Control result_back:
      call:
        resize(((64+32)*4), 200)
        move(8, 8)
        setStyle(style({
          background-color: "#4DD0E1",
          shadow: true,
          shadow-offset: "0 8"
        }))
      - Label text:
        call:
          setTextFont(loadFont(standard_font_path, 32))
          setTextColor(Color("#fff"))
          setTextAlign(1, 1, 1, 1)
          setAnchor(1, 1, 1, 1)
          setSizeAnchor(1, 0.5)
          setPadding(16, 16, 16, 16)


for i in 0..11:
  numbers.addChild(number_button.duplicate())
  if i < 9:
    numbers.getChild(i).ButtonRef.setText($(i+1))
    numbers.getChild(i).ButtonRef@onClick(self, x, y):
      query &= self.ButtonRef.getText()
      text.setText(query)
  elif i == 9:
    numbers.getChild(i).ButtonRef.setText(".")
    numbers.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0 and query[^1] != '.':
        query &= self.ButtonRef.getText()
        text.setText(query)
  elif i == 10:
    numbers.getChild(i).ButtonRef.setText("0")
    numbers.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0:
        query &= self.ButtonRef.getText()
        text.setText(query)
  elif i == 11:
    numbers.getChild(i).ButtonRef.setText("=")
    numbers.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0 and query[^1] in "/*-+":
        query = "0"
      var calculated = parseQuery(query).calculate()
      query = $calculated
      text.setText(query)

for i in 0..4:
  operators.addChild(operator_button.duplicate())
  case i
  of 0:
    operators.getChild(i).ButtonRef.setText("DEL")
    operators.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0:
        query = query[0..^2]
        text.setText(query)
  of 1:
    operators.getChild(i).ButtonRef.setText("+")
    operators.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0:
        if query[^1] notin "-+/*":
          query &= "+"
        else:
          query = query[0..^2] & "+"
        text.setText(query)
  of 2:
    operators.getChild(i).ButtonRef.setText("−")
    operators.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0:
        if query[^1] notin "-+/*":
          query &= "-"
        else:
          query = query[0..^2] & "-"
        text.setText(query)
  of 3:
    operators.getChild(i).ButtonRef.setText("÷")
    operators.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0:
        if query[^1] notin "-+/*":
          query &= "/"
        else:
          query = query[0..^2] & "/"
        text.setText(query)
  else:
    operators.getChild(i).ButtonRef.setText("×")
    operators.getChild(i).ButtonRef@onClick(self, x, y):
      if query.len > 0:
        if query[^1] notin "-+/*":
          query &= "*"
        else:
          query = query[0..^2] & "*"
        text.setText(query)


addMainScene(main)
runApp()
