# author: Ethosa
## This uses for create hero with physics.

import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  node2d,
  collision_shape2d


type
  KinematicBody2DObj* = object of Node2DObj
    has_collision*: bool
    collision_node*: CollisionShape2DPtr
  KinematicBody2DPtr* = ptr KinematicBody2DObj


proc KinematicBody2D*(name: string, variable: var KinematicBody2DObj): KinematicBody2DPtr =
  ## Creates a new KinematicBody2D pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a KinematicBody2DObj variable.
  runnableExamples:
    var
      node_obj: KinematicBody2DObj
      node = KinematicBody2D("KinematicBody2D", node_obj)
  nodepattern(KinematicBody2DObj)
  node2dpattern()
  variable.has_collision = false
  variable.kind = KINEMATIC_BODY_2D_NODE

proc KinematicBody2D*(obj: var KinematicBody2DObj): KinematicBody2DPtr {.inline.} =
  ## Creates a new KinematicBody2D pointer with deffault node name "KinematicBody2D".
  ##
  ## Arguments:
  ## - `variable` is a KinematicBody2DObj variable.
  runnableExamples:
    var
      node_obj: KinematicBody2DObj
      node = KinematicBody2D(node_obj)
  KinematicBody2D("KinematicBody2D", obj)


method addChild*(self: KinematicBody2DPtr, other: CollisionShape2DPtr) {.base.} =
  ## Adss collision to the KinematicBody2D.
  ## This method should be called one time.
  self.children.add(other)
  other.parent = self
  self.has_collision = true
  self.collision_node = other


method getCollideCount*(self: KinematicBody2DPtr): int {.base.} =
  ## Checks collision count.
  result = 0
  if self.has_collision:
    var scene = self.getRootNode()
    self.calcGlobalPosition()
    self.collision_node.calcGlobalPosition()

    for node in scene.getChildIter():
      if node.kind == COLLISION_SHAPE_2D_NODE:
        if node == self.collision_node:
          continue
        if self.collision_node.isCollide(node.CollisionShape2DPtr):
          inc result


method draw*(self: KinematicBody2DPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()

  self.position = self.timed_position

  if self.centered:
    self.position = self.timed_position - self.rect_size*2
  else:
    self.position = self.timed_position


method duplicate*(self: KinematicBody2DPtr, obj: var KinematicBody2DObj): KinematicBody2DPtr {.base.} =
  ## Duplicates KinematicBody2D and create a new KinematicBody2D pointer.
  obj = self[]
  obj.addr


method isCollide*(self: KinematicBody2DPtr): bool {.base.} =
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
        if self.collision_node.isCollide(node.CollisionShape2DPtr):
          result = true
          break


method moveAndCollide*(self: KinematicBody2DPtr, vel: Vector2Ref) {.base.} =
  ## Moves and checks collision
  ##
  ## Arguments:
  ## - `vel` is a velocity vector.
  if self.has_collision:
    var scene = self.getRootNode()
    self.move(vel)
    self.calcGlobalPosition()
    self.collision_node.calcGlobalPosition()

    for node in scene.getChildIter():
      if node.kind == COLLISION_SHAPE_2D_NODE:
        if node == self.collision_node:
          continue
        if self.collision_node.isCollide(node.CollisionShape2DPtr):
          self.move(-vel.x, 0)
          self.calcGlobalPosition()
          self.collision_node.calcGlobalPosition()

          if self.collision_node.isCollide(node.CollisionShape2DPtr):
            self.move(vel.x, -vel.y)
            self.calcGlobalPosition()
            self.collision_node.calcGlobalPosition()

          if self.collision_node.isCollide(node.CollisionShape2DPtr):
            self.move(-vel.x, 0)
            self.calcGlobalPosition()
            self.collision_node.calcGlobalPosition()
