# --- Test 18. Duplicate nodes. --- #
import nodesnim

var
  node1 = Node("Node1", )
  node2 = node1.duplicate()

  control1 = Control("Control1")
  control2 = control1.duplicate()

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
