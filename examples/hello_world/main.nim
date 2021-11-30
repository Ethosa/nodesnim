import nodesnim

Window("Hello, world!")


build:
  - Scene main_scene:
    - Label hello:
      call:
        setSizeAnchor(1, 1)
        setTextAlign(CENTER_ANCHOR)
        setText("Hello, world!")
        setBackgroundColor(Color(31, 45, 62))

addMainScene(main_scene)
runApp()
