# author: Ethosa
## Uses for runtime scene loading.
import
  ../core,
  ../nodes,
  ../nodescontrol,
  ../nodes2d,
  ../nodes3d,
  ../graphics,

  xmltree,
  xmlparser,
  tables,
  strtabs,
  strutils,
  macros


type
  KVPairSeq[T] = seq[tuple[key: string, val: T]]

proc `[]=`*[T](src: var KVPairSeq[T], key: string, val: T) =
  src.add((key: key, val: val))

proc hasKey*[T](src: KVPairSeq[T], key: string): bool =
  for i in src:
    if i.key == key:
      return true
  return false

iterator pairs*[T](src: KVPairSeq[T]): tuple[key: string, value: T] =
  for i in src:
    yield (key: i.key, value: i.val)


macro `mkattrs`*(properties_var, prop_list: untyped): untyped =
  if prop_list.kind != nnkStmtList and properties_var.kind != nnkCall:
    return

  result = newStmtList()

  for prop in prop_list:
    if prop.kind != nnkCall:
      continue
    var
      lambda = newProc(
        newEmptyNode(),
        [newEmptyNode(),
         newIdentDefs(properties_var[1], ident("NodeRef"), newEmptyNode()),
         newIdentDefs(properties_var[2], ident("string"), newEmptyNode())],
        prop[1]
      )
    result.add(
      newCall("[]=", properties_var[0], prop[0], lambda)
    )


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
  parsable*: KVPairSeq[proc (name: string): NodeRef] = @[]
  attrs*: KVPairSeq[proc (node: NodeRef, value: string)] = @[]

mkparse(Node, Scene, AudioStreamPlayer, AnimationPlayer)
mkparse(Control, Box, VBox, HBox, ColorRect, Label, SubWindow, ToolTip,
        Button, EditText, TextureButton, TextureRect, GridBox, CheckBox, Chart,
        Slider, Switch, Popup, Scroll, Counter, ProgressBar, TextureProgressBar)
mkparse(Node2D, Sprite, AnimatedSprite, KinematicBody2D, CollisionShape2D, TileMap, Camera2D, YSort)
mkparse(Node3D, Sprite3D, GeometryInstance)

mkattrs attrs(node, value):
  "color":
    node.ColorRectRef.color = Color(value)
  "name":
    node.name = value
  "text":
    node.LabelRef.setText(value)
  "image":
    node.TextureRectRef.loadTexture(value)
  "texture":
    if node.type_of_node == NODE_TYPE_2D:
      node.SpriteRef.loadTexture(value)
    elif node.type_of_node == NODE_TYPE_3D:
      node.Sprite3DRef.loadTexture(value)
  "background_color":
    node.ControlRef.setBackgroundColor(Color(value))
  "row":
    node.GridBoxRef.setRow(parseInt(value))
  "cell":
    node.GridBoxRef.setRow(parseInt(value))

  "anchor":
    let val = value.split(Whitespace)
    if val.len == 1:
      let v = parseFloat(val[0])
      node.ControlRef.setAnchor(v, v, v, v)
    elif val.len == 4:
      node.ControlRef.setAnchor(parseFloat(val[0]), parseFloat(val[1]),
                                parseFloat(val[2]), parseFloat(val[3]))

  "background":
    let val = value.split(Whitespace)
    var matches: array[20, string]
    for i in val:
      if matchColor(i):
        node.ControlRef.setBackgroundColor(Color(i))
      elif i.matchBackgroundImage(matches):
        node.ControlRef.background.loadTexture(matches[0])

  "size_anchor":
    let val = value.split(Whitespace)
    if val.len == 1:
      let v = parseFloat(val[0])
      node.ControlRef.setSizeAnchor(v, v)
    elif val.len == 2:
      node.ControlRef.setSizeAnchor(parseFloat(val[0]), parseFloat(val[1]))

  "style":
    if node.type_of_node == NODE_TYPE_CONTROL:
      var styles = StyleSheet()
      for item in value.split(";"):
        var style_info = item.split(":")
        styles[style_info[0]] =  style_info[1]
      node.ControlRef.setStyle(styles)


proc xmlAttr(xml: XmlNode, node: NodeRef) =
  if not xml.attrs.isNil():
    for attr, fn in attrs.pairs:
      if attr in xml.attrs:
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

proc loadSceneFromString*(scene_name, source: string): NodeRef =
  result = Scene(scene_name)
  var
    xml = parseXml(source)
    level: seq[NodeRef] = @[]
  level.add(result)
  xmlNode(xml, level)
