# author: Ethosa
## Uses for runtime scene loading.
import
  ../core,
  ../nodes,
  ../nodescontrol,
  ../nodes2d,
  ../nodes3d,

  xmltree,
  xmlparser,
  strtabs,
  tables,
  strutils,
  macros


var parsable = {
  # default
  "Node": Node, "Scene": Scene, "AudioStreamPlayer": AudioStreamPlayer,
  "AnimationPlayer": AnimationPlayer,
  # control
  "Control": Control, "Box": Box, "VBox": VBox, "HBox": HBox,
  "ColorRect": ColorRect, "Label": Label,"Button": Button, 
  "EditText": proc(name: string = "EditText"): EditTextRef = EditText(name, "Edit text ..."),
  "TextureButton": TextureButton, "TextureRect": TextureRect,
  "TextureProgressBar": TextureProgressBar, "Switch": Switch,
  "ToolTip": proc(name: string = "ToolTip"): ToolTipRef = ToolTip(name, "ToolTip"),
  "SubWindow": SubWindow, "Scroll": Scroll, "ProgressBar": ProgressBar, "Slider": Slider,
  "Popup": Popup, "Counter": Counter,
  # 2D
  "Node2D": Node2D, "Sprite": Sprite, "Sprite2D", "CollisionShape2D": CollisionShape2D,
  "KinematicBody2D": KinematicBody2D, "TileMap": TileMap, "Camera2D": Camera2D,
  "YSort": YSort,
  # 3D
  "Node3D": Node3D, "Sprite3D": Sprite3D, "Camera3D": Camera3D,
  "GeometryInstance": proc(name: string = "GeometryInstance"): GeometryInstanceRef =
                      GeometryInstance(name, GEOMETRY_CUBE)
}.toTable()


var properties = initTable[system.string, proc (node: NodeRef, value: string)]()
macro `!`(props, fn, code: untyped): untyped =
  let
    node = ident("node")
    value = ident("value")
  result = quote do:
    `props`[`fn[1]`] =
      proc(`node`: NodeRef, `value`: string) =
        `code`

properties!"color":
  node.ColorRectRef.color = Color(value)

properties!"name":
  node.name = value

properties!"text":
  node.LabelRef.setText(value)

properties!"style":
  if node.type_of_node == NODE_TYPE_CONTROL:
    var styles = StyleSheet()
    for item in value.split(";"):
      var style_info = item.split(":")
      styles[style_info[0]] =  style_info[1]
    node.ControlRef.setStyle(styles)

properties!"image":
  node.TextureRectRef.loadTexture(value)

properties!"texture":
  node.SpriteRef.loadTexture(value)

properties!"2dtexture":
  node.Sprite3DRef.loadTexture(value)

properties!"anchor":
  let val = value.split(Whitespace)
  if val.len == 1:
    let v = parseFloat(val[0])
    node.ControlRef.setAnchor(v, v, v, v)
  elif val.len == 4:
    node.ControlRef.setAnchor(parseFloat(val[0]), parseFloat(val[1]),
                                parseFloat(val[2]), parseFloat(val[3]))

properties!"size_anchor":
  let val = value.split(Whitespace)
  if val.len == 1:
    let v = parseFloat(val[0])
    node.ControlRef.setSizeAnchor(v, v)
  elif val.len == 2:
    node.ControlRef.setSizeAnchor(parseFloat(val[0]), parseFloat(val[1]))

properties!"background_color":
  node.ControlRef.setBackgroundColor(Color(value))

properties!"row":
  node.GridBoxRef.setRow(parseInt(value))

properties!"cell":
  node.GridBoxRef.setRow(parseInt(value))



proc xmlAttr(xml: XmlNode, node: NodeRef) =
  if not xml.attrs.isNil():
    for attr, fn in properties.pairs:
      if xml.attrs.hasKey(attr):
        fn(node, xml.attrs[attr])


proc xmlNode(xml: XmlNode, level: var seq[NodeRef]) =
  ## Converts xml tree to nodes.
  if level.len > 0 and parsable.hasKey(xml.tag):
    for key, node in parsable.pairs:
      if key == xml.tag:
        level[^1].addChild(node(key))
  level.add(level[^1].children[^1])

  # properties
  xmlAttr(xml, level[^1])

  # children
  for child in xml.items:
    xmlNode(child, level)

  if level.len > 0:
    discard level.pop()



proc loadScene*(file: string): NodeRef =
  ## Loads the scene from XML file.
  result = Scene(file.rsplit(".", 1)[0])
  var
    xml = loadXml(file)
    level: seq[NodeRef] = @[]
  level.add(result)
  xmlNode(xml, level)
