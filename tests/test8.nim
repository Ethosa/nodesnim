# --- Test 8. Make your own node. --- #
import
  nodesnim,
  nodesnim/runtime/scene_loader,  # For runtime load your node from XML scene file.
  strutils,
  tables


type
  MyOwnNodeObj* = object of NodeObj  # NodeObj/Node2DObj/ControlObj/Node3DObj
    property*: int
  MyOwnNodeRef* = ref MyOwnNodeObj


proc MyOwnNode*(name: string = "MyOwnNode"): MyOwnNodeRef =
  nodepattern(MyOwnNodeRef)
  # controlpattern()/node2dpattern()/node3dpattern()
  result.property = 100

# For XML scene files.
mkparse(MyOwnNode)
mkattrs attrs(node, value):
  "property":
    node.MyOwnNodeRef.property = value.parseInt()


build:
  - MyOwnNode node:
    property: 10

echo node.property

var source = "<MyOwnNode name=\"node1\" property=\"7\"></MyOwnNode>"
echo loadSceneFromString("TestScene", source)[0].MyOwnNodeRef.property
