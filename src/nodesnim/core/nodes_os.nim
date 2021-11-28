# author: Ethosa
import
  ../thirdparty/sdl2/ttf,
  os
when defined(linux):
  import distros
{.used.}

discard ttfInit()

let
  home_folder* = getHomeDir()
  nodesnim_folder* = home_folder / "NodesNim"
  saves_folder* = nodesnim_folder / "saves"

discard existsOrCreateDir(nodesnim_folder)
discard existsOrCreateDir(saves_folder)

var standard_font_path* =
  when defined(windows):
    "C://Windows/Fonts/segoeuib.ttf"
  elif defined(android):
    "/system/fonts/DroidSans.ttf"
  elif defined(linux):
    if detectOS(Ubuntu):
      "/usr/share/fonts/truetype/ubuntu/Ubuntu-R.ttf"
    else:
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
  else:
    currentSourcePath().parentDir() / "unifont.ttf"

if not fileExists(standard_font_path):
  standard_font_path = currentSourcePath().parentDir() / "unifont.ttf"


var standard_font*: FontPtr = nil

proc setStandardFont*(path: cstring, size: cint) =
  when defined(debug):
    echo "standard font path is " & standard_font_path
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
