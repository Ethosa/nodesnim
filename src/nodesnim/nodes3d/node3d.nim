# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/vector3,
  ../core/enums,
  ../core/anchor,
  ../core/input,

  ../nodes/node


type
  Node3DObj* = object of NodeObj
    rotation*, translation*, scale*: Vector3Obj
    global_rotation*, global_translation*, global_scale*: Vector3Obj
  Node3DRef* = ref Node3DObj


template node3dpattern* =
  result.rotation = Vector3()
  result.translation = Vector3()
  result.scale = Vector3()
  result.global_rotation = Vector3()
  result.global_translation = Vector3()
  result.global_scale = Vector3()
  result.node_type = NODE_TYPE_3D


proc Node3D*(name: string = "Node3D"): Node3DRef =
  ## Creates a new Node3D object.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = Node3D("Node3D")
  nodepattern(Node3DRef)
  node3dpattern()
  result.kind = NODE3D_NODE


method calcGlobalPosition3*(self: Node3DRef) =
  var current: NodeRef = self
  self.global_translation = self.translation
  self.global_rotation = self.rotation
  self.global_scale = self.scale

  while current.parent != nil:
    current = current.parent
    if current.node_type == NODE_TYPE_3D:
      self.global_translation += current.Node3DRef.translation
      self.global_rotation += current.Node3DRef.rotation
      self.global_scale += current.Node3DRef.scale


method rotate*(self: Node3DRef, x, y, z: float) {.base.} =
  self.rotation += Vector3(x, y, z)

method rotate*(self: Node3DRef, xyz: Vector3Obj) {.base.} =
  self.rotation += xyz

method rotateX*(self: Node3DRef, x: float) {.base.} =
  self.rotation.x += x

method rotateY*(self: Node3DRef, y: float) {.base.} =
  self.rotation.y += y

method rotateZ*(self: Node3DRef, z: float) {.base.} =
  self.rotation.z += z


method translate*(self: Node3DRef, x, y, z: float) {.base.} =
  self.translation += Vector3(x, y, z)

method translate*(self: Node3DRef, xyz: Vector3Obj) {.base.} =
  self.translation += xyz

method translateX*(self: Node3DRef, x: float) {.base.} =
  self.translation.x += x

method translateY*(self: Node3DRef, y: float) {.base.} =
  self.translation.y += y

method translateZ*(self: Node3DRef, z: float) {.base.} =
  self.translation.z += z


method transform*(self: Node3DRef, x, y, z: float) {.base.} =
  self.scale += Vector3(x, y, z)

method transform*(self: Node3DRef, xyz: Vector3Obj) {.base.} =
  self.scale += xyz

method transformX*(self: Node3DRef, x: float) {.base.} =
  self.scale.x += x

method transformY*(self: Node3DRef, y: float) {.base.} =
  self.scale.y += y

method transformZ*(self: Node3DRef, z: float) {.base.} =
  self.scale.z += z
