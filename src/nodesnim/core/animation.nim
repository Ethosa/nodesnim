# author: Ethosa


type
  AnimationObj*[T] = object
    frame*: int
    speed*, current*: float
    name*: string
    frames*: seq[T]
  AnimationRef*[T] = ref AnimationObj[T]
  AnimationArray*[T] = seq[AnimationRef[T]]


proc Animation*[T](name: string, speed: float = 1f): AnimationRef[T] =
  ## Creates a new Animation object.
  ##
  ## Arguments:
  ## - `name` is an animation name.
  ## - `speed` is an animation speed.
  runnableExamples:
    var
      anim = Animation[int]("animation", 10f)
  AnimationRef[T](name: name, speed: speed, current: 0f, frames: @[], frame: 0)


proc addFrame*[T](anim: AnimationRef[T], frame: T) =
  ## Adds a new frame in the animation.
  anim.frames.add(frame)


# --- Operators --- #
proc `==`*[T](x, y: AnimationRef[T]): bool {.inline.} =
  x.name == y.name and x.speed == y.speed and x.frames == y.frames

proc `[]`*[T](arr: AnimationArray[T], index: string): AnimationRef[T] =
  for elem in arr:
    if elem.name == index:
      return elem

proc contains*[T](arr: AnimationArray[T], animation: AnimationRef[T]): bool =
  result = false
  for elem in arr:
    if elem.name == animation.name:
      result = true
      break

proc contains*[T](arr: AnimationArray[T], name: string): bool =
  result = false
  for elem in arr:
    if elem.name == name:
      result = true
      break
