when defined(debug):
  import logging

  var console_logger = newConsoleLogger(fmtStr="[$time]::$levelname - ")
  var file_logger = newFileLogger("logs.log", fmtStr="[$date at $time]::$levelname - ")

  addHandler(console_logger)
  addHandler(file_logger)

  info("Compiled in debug mode.")


import
  nodesnim/thirdparty/opengl,
  nodesnim/thirdparty/opengl/glut,

  nodesnim/window,
  nodesnim/environment,

  nodesnim/core/vector2,
  nodesnim/core/rect2,
  nodesnim/core/circle2,
  nodesnim/core/enums,
  nodesnim/core/anchor,
  nodesnim/core/color,
  nodesnim/core/exceptions,
  nodesnim/core/input,
  nodesnim/core/image,
  nodesnim/core/color_text,
  nodesnim/core/audio_stream,
  nodesnim/core/animation,

  nodesnim/nodes/node,
  nodesnim/nodes/scene,
  nodesnim/nodes/canvas,
  nodesnim/nodes/audio_stream_player,

  nodesnim/nodescontrol/control,
  nodesnim/nodescontrol/color_rect,
  nodesnim/nodescontrol/texture_rect,
  nodesnim/nodescontrol/label,
  nodesnim/nodescontrol/button,
  nodesnim/nodescontrol/box,
  nodesnim/nodescontrol/hbox,
  nodesnim/nodescontrol/vbox,
  nodesnim/nodescontrol/grid_box,
  nodesnim/nodescontrol/edittext,
  nodesnim/nodescontrol/rich_label,
  nodesnim/nodescontrol/rich_edit_text,
  nodesnim/nodescontrol/scroll,
  nodesnim/nodescontrol/progress_bar,
  nodesnim/nodescontrol/vprogress_bar,
  nodesnim/nodescontrol/slider,
  nodesnim/nodescontrol/vslider,
  nodesnim/nodescontrol/popup,
  nodesnim/nodescontrol/texture_button,
  nodesnim/nodescontrol/texture_progress_bar,
  nodesnim/nodescontrol/counter,

  nodesnim/nodes2d/node2d,
  nodesnim/nodes2d/sprite,
  nodesnim/nodes2d/animated_sprite,
  nodesnim/nodes2d/ysort,
  nodesnim/nodes2d/collision_shape2d

export
  # Third party
  opengl, glut,
  # Main
  window, environment,
  # Core
  vector2, rect2, circle2, enums, anchor, color, exceptions, input, image, color_text,
  audio_stream, animation,
  # Default nodes
  node, scene, canvas, audio_stream_player,
  # Control nodes
  control, color_rect, texture_rect, label, button, box, hbox, vbox, grid_box, edittext,
  rich_label, rich_edit_text, scroll, progress_bar, vprogress_bar, slider, vslider, popup,
  texture_button, texture_progress_bar, counter,
  # 2D nodes
  node2d, sprite, animated_sprite, ysort, collision_shape2d
