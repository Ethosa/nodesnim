# author: Ethosa
## Provides animation in most nodes
import
  node,
  ../core/enums,
  ../core/tools,
  ../thirdparty/opengl


type
  AnimationObject* = object
    states: seq[tuple[tick: int, value: float]]
    obj: ptr float
  AnimationPlayerObj* {.final.} = object of NodeObj
    objects*: seq[AnimationObject]
    duration*: int64
    tick*: int64
    is_played*: bool
    loop*: bool
    bezier*: tuple[p0, p1: float]
    mode*: AnimationMode
  AnimationPlayerRef* = ref AnimationPlayerObj


proc AnimationPlayer*(name: string = "AnimationPlayer"): AnimationPlayerRef =
  runnableExamples:
    var animplayer = AnimationPlayer("AnimationPlayer")
  nodepattern(AnimationPlayerRef)
  result.objects = @[]
  result.bezier = (0.25, 0.75)
  result.duration = 180
  result.tick = 0
  result.is_played = false
  result.loop = true
  result.kind = ANIMATION_PLAYER_NODE
  result.type_of_node = NODE_TYPE_DEFAULT
  result.mode = ANIMATION_NORMAL


# --- Private --- #
proc ease(self: AnimationPlayerRef,
          states: seq[tuple[tick: int, value: float]]): float =
  var time = (self.tick - states[0].tick).float /
             ((states[1].tick - states[0].tick).float / 2.0)
  let diff = states[1].value - states[0].value
  if time < 1:
      return diff / 2 * time * time + states[0].value
  time -= 1
  -diff / 2 * (time * (time - 2) - 1) + states[0].value

proc bezier(self: AnimationPlayerRef,
            states: seq[tuple[tick: int, value: float]], current: float): float =
  let
    step = 1f / (states[1].tick - states[0].tick).float
    t = step * (self.tick - states[0].tick).float
    diff = states[1].value - states[0].value
  result = cubic_bezier(t, 0.0, self.bezier[0], self.bezier[1], 1.0)
  return states[0].value + diff*result


# --- Public --- #
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
          if self.tick == obj.states[i].tick:
            current[] = obj.states[i].value
          break
      if current_states.len == 1:
        for i in 0..obj.states.high:
          if current_states[0].tick < obj.states[i].tick:
            current_states.add(obj.states[i])
            break
    
      if current_states.len == 2:
        case self.mode
        of ANIMATION_NORMAL:
          let
            diff_time: float = (current_states[1].tick - current_states[0].tick).float
            diff: float = current_states[1].value - current_states[0].value
          current[] = current_states[0].value + (self.tick - current_states[0].tick).float/diff_time * diff
        of ANIMATION_EASE:
          current[] = ease(self, current_states)
        of ANIMATION_BEZIER:
          current[] = bezier(self, current_states, current[])
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
