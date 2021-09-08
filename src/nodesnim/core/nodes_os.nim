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

var standard_font*: FontPtr = nil

proc setStandardFont*(path: cstring, size: cint) =
  if not standard_font.isNil():
    standard_font.close()
  standard_font = openFont(path, size)

setStandardFont(currentSourcePath().parentDir() / "unifont.ttf", 16)
