when defined(debug):
  import logging

  var console_logger = newConsoleLogger(fmtStr="[$time]::$levelname - ")
  addHandler(console_logger)

  var file_logger = newFileLogger("logs.log", fmtStr="[$date at $time]::$levelname - ")
  addHandler(file_logger)

  info("Compiled in debug mode.")

import nodesnim/thirdparty/sdl2 except Color, glBindTexture
import
  nodesnim/thirdparty/gl,

  nodesnim/window,
  nodesnim/environment,

  nodesnim/core,
  nodesnim/graphics,
  nodesnim/nodes,
  nodesnim/nodescontrol,
  nodesnim/nodes2d,
  nodesnim/nodes3d

export
  # Third party
  gl, sdl2,
  # Main
  window, environment,
  # Nodes
  core, nodes, graphics,
  nodescontrol, nodes2d, nodes3d

when defined(debug):
  if standard_font.isNil():
    error("standard_font not loaded!")
