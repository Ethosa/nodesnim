# author: Ethosa
import
  ../thirdparty/sdl2/ttf,
  os
when defined(linux):
  import distros
when defined(debug):
  import logging
{.used.}

discard ttfInit()

let
  home_folder* = getHomeDir()
  nodesnim_folder* = home_folder / "NodesNim"
  saves_folder* = nodesnim_folder / "saves"

discard existsOrCreateDir(nodesnim_folder)
discard existsOrCreateDir(saves_folder)

let standard_font_path* =
  when defined(windows):
    "C://Windows/Fonts/segoeuib.ttf"
  elif defined(android):
    "/system/fonts/DroidSans.ttf"
  elif defined(linux):
    if detectOS(Ubuntu):
      getHomeDir() / "usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"
    else:
      currentSourcePath().parentDir() / "unifont.ttf"
  else:
    currentSourcePath().parentDir() / "unifont.ttf"

when defined(debug):
  info(standard_font_path)

var standard_font*: FontPtr = nil

proc setStandardFont*(path: cstring, size: cint) =
  if not standard_font.isNil():
    standard_font.close()
  standard_font = openFont(path, size)

proc norm*(a, b, c: float): float =
  if c < a:
    a
  elif c > b:
    b
  else:
    c

setStandardFont(standard_font_path, 16)
