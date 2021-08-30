import nodesnim

Window("Hello, world!")


build:
  - Scene scene:
    name: "Main"
    - Label hello:
      call setSizeAnchor(1, 1)
      call setTextAlign(0.5, 0.5, 0.5, 0.5)
      call setText("Hello, world!")
      background_color: Color(31, 45, 62)

addMainScene(scene)
windowLaunch()
