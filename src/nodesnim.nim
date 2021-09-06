when defined(debug):
  import logging

  var console_logger = newConsoleLogger(fmtStr="[$time]::$levelname - ")
  addHandler(console_logger)

  when not defined(android):
    var file_logger = newFileLogger("logs.log", fmtStr="[$date at $time]::$levelname - ")
    addHandler(file_logger)

  info("Compiled in debug mode.")


import
  nodesnim/thirdparty/opengl,
  nodesnim/thirdparty/opengl/glut,

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
  opengl, glut,
  # Main
  window, environment,
  graphics,
  # Nodes
  core, nodes,
  nodescontrol, nodes2d, nodes3d
