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


macro `!`(props, fn, code: untyped): untyped =
  let
    node = ident("node")
    value = ident("value")
  result = quote do:
    `props`[`fn[1]`] =
      proc(`node`: NodeRef, `value`: string) =
        `code`

macro mkparse*(nodes: varargs[untyped]): untyped =
  result = newStmtList()
  for node in nodes:
    if node.kind in [nnkIdent, nnkStrLit]:
      let
        name = ident($node)
        strname = $node
        refname = ident(strname & "Ref")
      result.add:
        quote do:
          parsable[`strname`] = proc(name: string = `strname`): `refname` = `name`(`strname`)


var
  parsable = initTable[system.string, proc (name: string): NodeRef]()
  properties = initTable[system.string, proc (node: NodeRef, value: string)]()

mkparse(Node, Scene, AudioStreamPlayer, AnimationPlayer)
mkparse(Control, Box, VBox, HBox, ColorRect, Label, SubWindow, ToolTip,
        Button, EditText, TextureButton, TextureRect, GridBox, CheckBox,
        Slider, Switch, Popup, Scroll, Counter, ProgressBar, TextureProgressBar)
mkparse(Node2D, Sprite, AnimatedSprite, KinematicBody2D, CollisionShape2D, TileMap, Camera2D, YSort)
mkparse(Node3D, Sprite3D, GeometryInstance)


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
