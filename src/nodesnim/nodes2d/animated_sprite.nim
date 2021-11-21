# author: Ethosa
## It provides display animated sprites.
import
  ../thirdparty/gl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,
  ../core/image,
  ../core/color,
  ../core/animation,
  ../private/templates,

  ../nodes/node,
  node2d


type
  AnimatedSpriteObj* = object of Node2DObj
    reversed*, paused*: bool
    filter*: ColorRef
    animation*: string
    animations*: AnimationArray[GlTextureObj]
  AnimatedSpriteRef* = ref AnimatedSpriteObj



proc AnimatedSprite*(name: string = "AnimatedSprite"): AnimatedSpriteRef =
  ## Creates a new AnimatedSprite.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = AnimatedSprite("AnimatedSprite")
  nodepattern(AnimatedSpriteRef)
  node2dpattern()
  result.filter = Color(1f, 1f, 1f)
  result.animations = @[Animation[GlTextureObj]("default", 2f)]
  result.animation = "default"
  result.paused = true
  result.reversed = false
  result.kind = ANIMATED_SPRITE_NODE


method draw*(self: AnimatedSpriteRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  let
    frame = self.animations[self.animation].frame
    frames_count = self.animations[self.animation].frames.len()
  if frame >= 0 and frame < frames_count:
    var texture = self.animations[self.animation].frames[frame]
    if texture.texture > 0'u32:
      self.rect_size = texture.size

  # Recalculate position.
  procCall self.Node2DRef.draw(w, h)
  self.calcGlobalPosition()

  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y

  # Draw frame
  if frame >= 0 and frame < frames_count:
    var texture = self.animations[self.animation].frames[frame]
    if texture.texture > 0'u32:
      glPushMatrix()
      if self.centered:
        glTranslatef(x + (self.rect_size.x / 2), y - (self.rect_size.y / 2), self.z_index_global)
        self.position = self.rect_size / 2
      else:
        glTranslatef(x, y, self.z_index_global)
        self.position = Vector2()
      glRotatef(self.rotation, 0, 0, 1)
      glColor4f(self.filter.r, self.filter.g, self.filter.b, self.filter.a)

      glEnable(GL_TEXTURE_2D)
      glEnable(GL_DEPTH_TEST)
      glBindTexture(GL_TEXTURE_2D, texture.texture)

      glBegin(GL_QUADS)
      glTexCoord2f(0, 0)
      glVertex3f(-self.position.x, self.position.y, self.z_index_global)
      glTexCoord2f(0, 1)
      glVertex3f(-self.position.x, self.position.y - self.rect_size.y, self.z_index_global)
      glTexCoord2f(1, 1)
      glVertex3f(-self.position.x + self.rect_size.x, self.position.y - self.rect_size.y, self.z_index_global)
      glTexCoord2f(1, 0)
      glVertex3f(-self.position.x + self.rect_size.x, self.position.y, self.z_index_global)
      glEnd()
      glDisable(GL_DEPTH_TEST)
      glDisable(GL_TEXTURE_2D)
      glPopMatrix()
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


method duplicate*(self: AnimatedSpriteRef): AnimatedSpriteRef {.base.} =
  ## Duplicates AnimatedSprite object and create a new AnimatedSprite.
  self.deepCopy()

method addAnimation*(self: AnimatedSpriteRef, name: string, speed: float = 2f) {.base.} =
  ## Adds a new animation to the AnimatedSprite animations.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  ## - `speed` is an animation speed.
  var newanim = Animation[GlTextureObj](name, speed)
  if newanim notin self.animations:
    self.animations.add(newanim)

method addFrame*(self: AnimatedSpriteRef, name: string, frame: GlTextureObj) {.base.} =
  ## Adds a new frame in the animation.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  self.animations[name].addFrame(frame)

method removeAnimation*(self: AnimatedSpriteRef, name: string) {.base.} =
  ## Deletes animation from the AnimatedSprite animations.
  ## If `name` is a current animation name, then animation will not delete.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  if name == self.animation:
    return
  for i in 0..self.animations.high:
    if self.animations[i].name == name:
      for j in 0..self.animations[i].frames.high:
        glDeleteTextures(1, addr self.animations[i].frames[j].texture)
      self.animations.delete(i)
      break

method pause*(self: AnimatedSpriteRef) {.base.} =
  ## Stops animation.
  self.paused = true

method play*(self: AnimatedSpriteRef, name: string = "", backward: bool = false) {.base.} =
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

method resume*(self: AnimatedSpriteRef) {.base.} =
  ## Resumes animation.
  self.paused = false

method setSpeed*(self: AnimatedSpriteRef, name: string = "", speed: float = 2f) {.base.} =
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
