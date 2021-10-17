# --- Test 8. Make your own node. --- #
import nodesnim


type
  MyOwnNodeRef = ref MyOwnNodeObj
  MyOwnNodeObj = object of NodeRef  # NodeRef/Node2DRef/ControlRef/Node3DRef
    property: int


proc MyOwnNode(name: string = "MyOwnNode"): MyOwnNodeRef =
  nodepattern(MyOwnNodeRef)
  # controlpattern()/node2dpattern()/node3dpattern()
  result.property = 100


build:
  - MyOwnNode node:
    property: 10

echo node.property
