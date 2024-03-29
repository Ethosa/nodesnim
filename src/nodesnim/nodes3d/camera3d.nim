# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector3,
  ../core/input,
  ../core/enums,
  ../private/templates,

  ../nodes/node,
  node3d,
  math

type
  Camera3DObj* = object of Node3DObj
    pitch*, yaw*: float
    target*: Node3DRef
    front*: Vector3Obj
    up*: Vector3Obj
    right*: Vector3Obj
  Camera3DRef* = ref Camera3DObj


var current_camera*: Camera3DRef = nil


proc Camera3D*(name: string = "Camera3D"): Camera3DRef =
  ## Creates a new Camera3D.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = Camera3D("Camera3D")
  nodepattern(Camera3DRef)
  node3dpattern()
  result.kind = CAMERA_3D_NODE
  result.front = Vector3(0, 0, 1)
  result.up = Vector3(0, 1, 0)
  result.right = Vector3()
  result.pitch = 0f
  result.yaw = 90f


method changeTarget*(self: Camera3DRef, target: Node3DRef) {.base.} =
  ## Changes camera target (without camera position.)
  self.target = target

method draw*(self: Camera3DRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition3()

  if self.pitch < -89f:
    self.pitch = -89f
  elif self.pitch > 89f:
    self.pitch = 89f

  self.front = Vector3(
    cos(degToRad(self.yaw)) * cos(degToRad(self.pitch)),
    sin(degToRad(self.pitch)),
    sin(degToRad(self.yaw)) * cos(degToRad(self.pitch))).normalized()
  self.right = self.front.cross(self.up).normalized()

method isCurrent*(self: Camera3DRef): bool {.base.} =
  self == current_camera

method setCurrent*(self: Camera3DRef) {.base.} =
  ## Changes the current camera. It also automatically disable other cameras.
  current_camera = self

method rotateX*(self: Camera3DRef, val: float) =
  self.yaw += val

method rotateY*(self: Camera3DRef, val: float) =
  self.pitch += val

method rotate*(self: Camera3DRef, x, y: float) {.base.} =
  ## Rotates camera by `x` and `y` values.
  self.yaw += x
  self.pitch += y
