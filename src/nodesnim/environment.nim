# author: Ethosa
import
  core/color,
  core/enums
{.used.}


type
  EnvironmentObj* = object
    color*: ColorRef         ## background environment color.
    screen_mode*: ScreenMode
    delay*: int              ## window delay.
  EnvironmentRef* = ref EnvironmentObj


proc newEnvironment*(color: ColorRef): EnvironmentRef =
  ## Creates a new EnvironmentRef object.
  ##
  ## Arguments:
  ## - `color`: ColorRef object for background environment color.
  ## - `brightness` - window brightness with value in range `0..1`
  EnvironmentRef(color: color, delay: 17,screen_mode: SCREEN_MODE_NONE)

proc newEnvironment*(): EnvironmentRef {.inline.} =
  ## Creates a new EnvironmentRef object.
  newEnvironment(Color(0x313131ff))


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

proc setDelay*(env: EnvironmentRef, delay: int) =
  ## Changes window delay.
  ##
  ## Arguments:
  ## - `delay`: should be ``1000 div FPS``, e.g.: ``1000 div 60 for 60`` frames per second.
  env.delay = delay

proc setScreenMode*(env: EnvironmentRef, mode: ScreenMode) =
  ## Changes screen mode.
  ## `mode` should be `SCREEN_MODE_NONE` or `SCREEN_MODE_EXPANDED`.
  env.screen_mode = mode
