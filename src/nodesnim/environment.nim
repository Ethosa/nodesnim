# author: Ethosa
import core/color
{.used.}


type
  EnvironmentObj* = object
    delay*: int    ## window delay.
    color*: ColorRef  ## background environment color.
    brightness*: float
  EnvironmentRef* = ref EnvironmentObj


proc newEnvironment*(color: ColorRef, brightness: float): EnvironmentRef =
  ## Creates a new EnvironmentRef object.
  ##
  ## Arguments:
  ## - `color`: ColorRef object for background environment color.
  ## - `brightness` - window brightness with value in range `0..1`
  EnvironmentRef(color: color, delay: 17, brightness: brightness)

proc newEnvironment*(): EnvironmentRef {.inline.} =
  ## Creates a new EnvironmentRef object.
  newEnvironment(Color(0x313131ff), 1.0)


proc setBackgroundColor*(env: EnvironmentRef, color: ColorRef) =
  ## Changes background environment color.
  ##
  ## Arguments:
  ## - `color`: ColorRef object.
  env.color = color

proc setBackgroundColor*(env: EnvironmentRef, color: uint32) =
  ## Changes background environment color.
  ##
  ## Arguments:
  ## - `color`: uint32 color, e.g.: 0xFF64FF
  env.color = Color(color)

proc setBrightness*(env: EnvironmentRef, brightness: float) =
  ## Changes window brightness.
  ##
  ## Arguments:
  ## - `brightness` - window brightness with value in range `0..1`
  env.brightness = brightness

proc setDelay*(env: EnvironmentRef, delay: int) =
  ## Changes window delay.
  ##
  ## Arguments:
  ## - `delay`: should be ``1000 div FPS``, e.g.: ``1000 div 60 for 60`` frames per second.
  env.delay = delay
