# author: Ethosa
import os


when defined(windows):
    const home_folder* = getHomeDir() / "AppData" / "Roaming"
else:
    const home_folder* = getHomeDir()

const
  nodesnim_folder* = home_folder / "NodesNim"
  saves_folder* = "NodesNim" / "saves"

discard existsOrCreateDir(nodesnim_folder)
discard existsOrCreateDir(home_folder / saves_folder)
