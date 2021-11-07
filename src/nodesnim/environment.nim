# author: Ethosa
import
  thirdparty/sdl2,
  core/color,
  core/themes,
  core/enums
{.used.}


type
  EnvironmentObj* = object
    windowptr*: WindowPtr  ## window pointer
    color_value: ColorRef
    screen_mode_value: ScreenMode
    delay_value: int
    brightness_value: float
    grabbed_value: bool
    fullscreen_value: bool
    bordered_value: bool
    resizable_value: bool
  EnvironmentRef* = ref EnvironmentObj


proc newEnvironment*(color: ColorRef = nil, brightness: float = 1f,
                     windowptr: WindowPtr = nil): EnvironmentRef =
  ## Creates a new EnvironmentRef object.
  ##
  ## Arguments:
  ## - `color`: ColorRef object for background environment color.
  ## - `brightness` - window brightness with value in range `0..1`
  if not windowptr.isNil():
    discard windowptr.setBrightness(normalize(brightness, 0f, 1f))

  var clr = color
  if clr.isNil():
    clr = current_theme~background

  EnvironmentRef(color_value: clr, delay_value: 17,
    screen_mode_value: SCREEN_MODE_NONE, brightness_value: brightness,
    windowptr: windowptr, grabbed_value: false, fullscreen_value: false,
    resizable_value: true)


proc `delay`*(env: EnvironmentRef): int = env.delay_value
proc `delay=`*(env: EnvironmentRef, value: int) =
  env.delay_value = value

proc `background_color`*(env: EnvironmentRef): ColorRef = env.color_value
proc `background_color=`*(env: EnvironmentRef, value: ColorRef) =
  env.color_value = value
proc `background_color=`*(env: EnvironmentRef, value: uint32) =
  env.color_value = Color(value)
proc `background_color=`*(env: EnvironmentRef, value: string) =
  env.color_value = Color(value)

proc `grabbed`*(env: EnvironmentRef): bool = env.grabbed_value
proc `grabbed=`*(env: EnvironmentRef, value: bool) =
  when not defined(android) and not defined(ios):
    if not env.windowptr.isNil():
      env.windowptr.setGrab(value.Bool32)
  env.grabbed_value = value

proc `fullscreen`*(env: EnvironmentRef): bool = env.fullscreen_value
proc `fullscreen=`*(env: EnvironmentRef, value: bool) =
  when not defined(android) and not defined(ios):
    if not env.windowptr.isNil():
      discard env.windowptr.setFullscreen(if value: SDL_WINDOW_FULLSCREEN else: 0)
  env.fullscreen_value = value

proc `bordered`*(env: EnvironmentRef): bool = env.bordered_value
proc `bordered=`*(env: EnvironmentRef, value: bool) =
  when not defined(android) and not defined(ios):
    if not env.windowptr.isNil():
      env.windowptr.setBordered(value.Bool32)
  env.bordered_value = value

proc `resizable`*(env: EnvironmentRef): bool = env.resizable_value
proc `resizable=`*(env: EnvironmentRef, value: bool) =
  when not defined(android) and not defined(ios):
    if not env.windowptr.isNil():
      env.windowptr.setResizable(value.Bool32)
  env.resizable_value = value

proc `brightness`*(env: EnvironmentRef): float = env.brightness_value
proc `brightness=`*(env: EnvironmentRef, value: float) =
  if not env.windowptr.isNil():
    discard env.windowptr.setBrightness(normalize(value, 0f, 1f))
  env.brightness_value = value

proc `screen_mode`*(env: EnvironmentRef): ScreenMode = env.screen_mode_value
proc `screen_mode=`*(env: EnvironmentRef, value: ScreenMode) =
  env.screen_mode_value = value
