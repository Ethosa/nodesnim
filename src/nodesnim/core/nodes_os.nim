# author: Ethosa
import
  ../thirdparty/sdl2/ttf,
  os
{.used.}

discard ttfInit()

const
  home_folder* = getHomeDir()
  nodesnim_folder* = home_folder / "NodesNim"
  saves_folder* = "NodesNim" / "saves"

discard existsOrCreateDir(nodesnim_folder)
discard existsOrCreateDir(home_folder / saves_folder)

let standard_font_path* =
  when defined(windows):
    "C://Windows/Fonts/segoeuib.ttf"
  elif defined(android):
    "/system/fonts/DroidSans.ttf"
  else:
      currentSourcePath().parentDir() / "unifont.ttf"
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
