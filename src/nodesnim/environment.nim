# author: Ethosa
import core/color
{.used.}


type
  EnvironmentObj* = object
    delay*: uint32    ## window delay.
    color*: ColorRef  ## background environment color.
  EnvironmentRef* = ref EnvironmentObj


proc newEnvironment*(color: ColorRef): EnvironmentRef =
  ## Creates a new EnvironmentRef object.
  ##
  ## Arguments:
  ## - `color`: ColorRef object for background environment color.
  EnvironmentRef(color: color, delay: 17)

proc newEnvironment*(): EnvironmentRef {.inline.} =
  ## Creates a new EnvironmentRef object.
  newEnvironment(Color(0x313131ff))


proc setBackgroundColor*(env: EnvironmentRef, color: ColorRef): void =
  ## Changes background environment color.
  ##
  ## Arguments:
  ## - `color`: ColorRef object.
  env.color = color

proc setBackgroundColor*(env: EnvironmentRef, color: uint32): void =
  ## Changes background environment color.
  ##
  ## Arguments:
  ## - `color`: uint32 color, e.g.: 0xFF64FF
  env.color = Color(color)

proc setDelay*(env: EnvironmentRef, delay: uint32): void =
  ## Changes window delay.
  ##
  ## Arguments:
  ## - `delay`: should be ``1000 div FPS``, e.g.: ``1000 div 60 for 60`` frames per second.
  env.delay = delay
