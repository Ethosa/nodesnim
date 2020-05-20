# --- Test 18. Dublicate nodes. --- #
import nodesnim

var
  node1obj: NodeObj
  node2obj: NodeObj
  node1 = Node("Node1", node1obj)
  node2 = node1.dublicate(node2obj)

  control1obj: ControlObj
  control2obj: ControlObj
  control1 = Control("Control1", control1obj)
  control2 = control1.dublicate(control2obj)

node2.name = "Node2"
node2.rect_size = Vector2(100, 100)

echo node1.name
echo node2.name

echo node1.rect_size
echo node2.rect_size

control2.name = "Control2"
control2.rect_size = Vector2(100, 100)

echo control1.name
echo control2.name

echo control1.rect_size
echo control2.rect_size
