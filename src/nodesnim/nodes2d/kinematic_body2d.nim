# author: Ethosa
## This uses for create hero with physics.

import
  ../thirdparty/gl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../private/templates,

  ../nodes/node,
  ../nodes/canvas,
  node2d,
  collision_shape2d


type
  KinematicBody2DObj* = object of Node2DObj
    has_collision*: bool
    collision_node*: CollisionShape2DRef
  KinematicBody2DRef* = ref KinematicBody2DObj


proc KinematicBody2D*(name: string = "KinematicBody2D"): KinematicBody2DRef =
  ## Creates a new KinematicBody2D.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = KinematicBody2D("KinematicBody2D")
  nodepattern(KinematicBody2DRef)
  node2dpattern()
  result.has_collision = false
  result.kind = KINEMATIC_BODY_2D_NODE


method addChild*(self: KinematicBody2DRef, other: CollisionShape2DRef) {.base.} =
  ## Adss collision to the KinematicBody2D.
  ## This method should be called one time.
  self.children.add(other)
  other.parent = self
  self.has_collision = true
  self.collision_node = other


method getCollideCount*(self: KinematicBody2DRef): int {.base.} =
  ## Checks collision count.
  result = 0
  if self.has_collision:
    var scene = self.getRootNode()
    self.CanvasRef.calcGlobalPosition()
    self.collision_node.calcGlobalPosition()

    for node in scene.getChildIter():
      if node.kind == COLLISION_SHAPE_2D_NODE:
        if node == self.collision_node:
          continue
        if self.collision_node.isCollide(node.CollisionShape2DRef):
          inc result


method draw*(self: KinematicBody2DRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  procCall self.Node2DRef.draw(w, h)


method duplicate*(self: KinematicBody2DRef): KinematicBody2DRef {.base.} =
  ## Duplicates KinematicBody2D and create a new KinematicBody2D pointer.
  self.deepCopy()


method isCollide*(self: KinematicBody2DRef): bool {.base.} =
  ## Checks any collision and return `true`, when collide with any collision shape.
  result = false
  if self.has_collision:
    var scene = self.getRootNode()
    self.calcGlobalPosition()
    self.collision_node.calcGlobalPosition()

    for node in scene.getChildIter():
      if node.kind == COLLISION_SHAPE_2D_NODE:
        if node == self.collision_node:
          continue
        if self.collision_node.isCollide(node.CollisionShape2DRef):
          result = true
          break


method moveAndCollide*(self: KinematicBody2DRef, vel: Vector2Obj) {.base.} =
  ## Moves and checks collision
  ##
  ## Arguments:
  ## - `vel` is a velocity vector.
  # TODO: normal algorithn
  let
    biggest = max(vel.x.abs(), vel.y.abs())
    step = Vector2(vel.x/biggest, vel.y/biggest)
    vec = vel.abs()
    scene = self.getRootNode()
  var v = Vector2()

  while v.x < vec.x or v.y < vec.y:
    self.move(step)
    if self.has_collision:
      for node in scene.getChildIter():
        if node.kind == COLLISION_SHAPE_2D_NODE:
          if node == self.collision_node:
            continue
          let collision_node = node.CollisionShape2DRef

          if self.collision_node.isCollide(collision_node):
            self.move(-step.x, 0)
            self.collision_node.calcGlobalPosition()

            if self.collision_node.isCollide(collision_node):
              self.move(step.x, -step.y)
              self.collision_node.calcGlobalPosition()

            if self.collision_node.isCollide(collision_node):
              self.move(-step.x, 0)
              self.collision_node.calcGlobalPosition()
    v += step.abs()
