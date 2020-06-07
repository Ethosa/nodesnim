# author: Ethosa
import os
{.used.}


const
  home_folder* = getHomeDir()
  nodesnim_folder* = home_folder / "NodesNim"
  saves_folder* = "NodesNim" / "saves"

discard existsOrCreateDir(nodesnim_folder)
discard existsOrCreateDir(home_folder / saves_folder)
