import
  nodesnim/window,
  nodesnim/core/anchor,
  nodesnim/core/scene_builder,
  nodesnim/core/color,
  nodesnim/nodes/scene,
  nodesnim/nodes/node,
  nodesnim/nodes/canvas,
  nodesnim/nodescontrol/label,
  nodesnim/nodescontrol/control

Window("Hello, world!")


build:
  - Scene main_scene:
    - Label hello:
      call:
        setSizeAnchor(1, 1)
        setTextAlign(0.5, 0.5, 0.5, 0.5)
        setText("Hello, world!")
        setBackgroundColor(Color(31, 45, 62))

addMainScene(main_scene)
windowLaunch()
