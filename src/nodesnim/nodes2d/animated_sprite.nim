# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/image,
  ../core/color,
  ../core/animation,

  ../nodes/node,
  node2d


type
  AnimatedSpriteObj* = object of Node2DObj
    reversed*, paused*: bool
    filter*: ColorRef
    animation*: string
    animations*: AnimationArray[GlTextureObj]
  AnimatedSpritePtr* = ptr AnimatedSpriteObj



proc AnimatedSprite*(name: string, variable: var AnimatedSpriteObj): AnimatedSpritePtr =
  ## Creates a new AnimatedSprite pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a AnimatedSpriteObj variable.
  runnableExamples:
    var
      node_obj: AnimatedSpriteObj
      node = AnimatedSprite("AnimatedSprite", node_obj)
  nodepattern(AnimatedSpriteObj)
  node2dpattern()
  variable.filter = Color(1f, 1f, 1f)
  variable.animations = @[Animation[GlTextureObj]("default", 2f)]
  variable.animation = "default"
  variable.paused = true
  variable.reversed = false

proc AnimatedSprite*(obj: var AnimatedSpriteObj): AnimatedSpritePtr {.inline.} =
  ## Creates a new AnimatedSprite pointer with default node name "AnimatedSprite".
  ##
  ## Arguments:
  ## - `variable` is a AnimatedSpriteObj variable.
  runnableExamples:
    var
      node_obj: AnimatedSpriteObj
      node = AnimatedSprite(node_obj)
  AnimatedSprite("AnimatedSprite", obj)

method draw*(self: AnimatedSpritePtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  let
    frame = self.animations[self.animation].frame
    frames_count = self.animations[self.animation].frames.len()
  if frame >= 0 and frame < frames_count:
    var texture = self.animations[self.animation].frames[frame]
    if texture.texture > 0:
      self.rect_size = texture.size

  # Recalculate position.
  self.position = self.timed_position
  if self.centered:
    self.position = self.timed_position - self.rect_size/2
  else:
    self.position = self.timed_position

  self.calcGlobalPosition()
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Draw frame
  if frame >= 0 and frame < frames_count:
    var texture = self.animations[self.animation].frames[frame]
    if texture.texture > 0:
      glColor4f(self.filter.r, self.filter.g, self.filter.b, self.filter.a)

      glEnable(GL_TEXTURE_2D)
      glBindTexture(GL_TEXTURE_2D, texture.texture)

      glBegin(GL_QUADS)
      glTexCoord2f(0, 0)
      glVertex3f(x, y, self.z_index)
      glTexCoord2f(0, 1)
      glVertex3f(x, y - self.rect_size.y, self.z_index)
      glTexCoord2f(1, 1)
      glVertex3f(x + self.rect_size.x, y - self.rect_size.y, self.z_index)
      glTexCoord2f(1, 0)
      glVertex3f(x + self.rect_size.x, y, self.z_index)
      glEnd()
      glDisable(GL_TEXTURE_2D)
    else:
      self.rect_size = Vector2()

  # Change frame
  if not self.paused:
    if self.animations[self.animation].current < 60f:
      self.animations[self.animation].current += self.animations[self.animation].speed
    else:
      self.animations[self.animation].current = 0f
      if self.reversed:
        if frame - 1 < 0:
          self.animations[self.animation].frame = frames_count-1
        else:
          self.animations[self.animation].frame -= 1
      else:
        if frame + 1 > frames_count-1:
          self.animations[self.animation].frame = 0
        else:
          self.animations[self.animation].frame += 1


method duplicate*(self: AnimatedSpritePtr, obj: var AnimatedSpriteObj): AnimatedSpritePtr {.base.} =
  ## Duplicates AnimatedSprite object and create a new AnimatedSprite pointer.
  obj = self[]
  obj.addr

method getGlobalMousePosition*(self: AnimatedSpritePtr): Vector2Ref {.inline.} =
  ## Returns mouse position.
  Vector2Ref(x: last_event.x, y: last_event.y)

method addAnimation*(self: AnimatedSpritePtr, name: string, speed: float = 2f) {.base.} =
  ## Adds a new animation to the AnimatedSprite animations.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  ## - `speed` is an animation speed.
  var newanim = Animation[GlTextureObj](name, speed)
  if newanim notin self.animations:
    self.animations.add(newanim)

method addFrame*(self: AnimatedSpritePtr, name: string, frame: GlTextureObj) {.base.} =
  ## Adds a new frame in the animation.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  self.animations[name].addFrame(frame)

method removeAnimation*(self: AnimatedSpritePtr, name: string) {.base.} =
  ## Deletes animation from the AnimatedSprite animations.
  ## If `name` is a current animation name, then animation will not delete.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  if name == self.animation:
    return
  for i in 0..self.animations.high:
    if self.animations[i].name == name:
      self.animations.delete(i)
      break

method pause*(self: AnimatedSpritePtr) {.base.} =
  ## Stops animation.
  self.paused = true

method play*(self: AnimatedSpritePtr, name: string = "", backward: bool = false) {.base.} =
  ## Plays animation.
  ##
  ## Arguments:
  ## - `name` is an animation name. if it is "" than plays current animation.
  ## - if `backward` is true then plays animation in reverse order.
  if name != "":
    self.animation = name
  self.reversed = backward
  self.animations[self.animation].current = 0f
  if self.reversed:
    self.animations[self.animation].frame = self.animations[self.animation].frames.len()-1
  else:
    self.animations[self.animation].frame = 0
  self.paused = false

method resume*(self: AnimatedSpritePtr) {.base.} =
  ## Resumes animation.
  self.paused = false

method setSpeed*(self: AnimatedSpritePtr, name: string = "", speed: float = 2f) {.base.} =
  ## Changes animation speed.
  ## If `name` is "" then changes the speed of the current animation.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  ## - `speed` is a new speed.
  if name == "":
    self.animations[self.animation].speed = speed
  else:
    self.animations[name].speed = speed
