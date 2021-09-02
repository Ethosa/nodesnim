# author: Ethosa
## Provides animation in most nodes
import
  node,
  ../core/enums,
  ../thirdparty/opengl


type
  AnimationMode* {.pure, size: sizeof(int8).} = enum
    ANIMATION_NORMAL,
    ANIMATION_EASE
  AnimationObject* = object
    states: seq[tuple[tick: int, value: float]]
    obj: ptr float
  AnimationPlayerObj* {.final.} = object of NodeObj
    objects*: seq[AnimationObject]
    duration*: int64
    tick*: int64
    is_played*: bool
    loop*: bool
    mode*: AnimationMode
  AnimationPlayerRef* = ref AnimationPlayerObj


proc AnimationPlayer*(name: string = "AnimationPlayer"): AnimationPlayerRef =
  runnableExamples:
    var animplayer = AnimationPlayer("AnimationPlayer")
  nodepattern(AnimationPlayerRef)
  result.objects = @[]
  result.duration = 180
  result.tick = 0
  result.is_played = false
  result.loop = true
  result.kind = ANIMATION_PLAYER_NODE
  result.type_of_node = NODE_TYPE_DEFAULT
  result.mode = ANIMATION_NORMAL


proc ease(self: AnimationPlayerRef, states: seq[tuple[tick: int, value: float]]): float =
    var time = (self.tick - states[0].tick).float / ((states[1].tick - states[0].tick).float / 2.0)
    let diff = states[1].value - states[0].value
    if time < 1:
        return diff / 2 * time * time + states[0].value
    time -= 1
    return -diff / 2 * (time * (time - 2) - 1) + states[0].value


method addState*(self: AnimationPlayerRef, obj: ptr float, states: seq[tuple[tick: int, value: float]]) {.base.} =
  ## Adds a new state to AnimationPlayer.
  self.objects.add(AnimationObject(
    states: states,
    obj: obj
  ))

method draw*(self: AnimationPlayerRef, w: GLfloat, h: GLfloat) =
  ## This uses in the `window.nim`.
  if self.is_played:
    if self.tick > self.duration:
        self.tick = 0
        if not self.loop:
            self.is_played = false
            return

    var
      current_states: seq[tuple[tick: int, value: float]] = @[]
      current: ptr float
    for obj in self.objects:
      current = obj.obj
      for i in countdown(obj.states.high, 0):
        if self.tick >= obj.states[i].tick:
          current_states.add(obj.states[i])
          break
      if current_states.len() == 1:
        for i in 0..obj.states.high:
          if current_states[0].tick < obj.states[i].tick:
            current_states.add(obj.states[i])
            break
    
      if current_states.len() == 2:
        if self.mode == ANIMATION_NORMAL:
          let
            diff_time: float = (current_states[1].tick - current_states[0].tick).float
            diff: float = current_states[1].value - current_states[0].value
          current[] = current_states[0].value + (self.tick - current_states[0].tick).float/diff_time * diff
        else:
          current[] = self.ease(current_states)
      current_states = @[]

    self.tick += 1

method play*(self: AnimationPlayerRef) {.base.} =
  ## Plays animation.
  self.is_played = true

method setDuration*(self: AnimationPlayerRef, duration: int) {.base.} =
  ## Changes animation duration.
  self.duration = duration

method stop*(self: AnimationPlayerRef) {.base.} =
  ## Stops animation.
  self.is_played = false
