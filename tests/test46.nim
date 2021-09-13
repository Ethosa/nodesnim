# --- Test 46. Use Padding. --- #
import nodesnim


Window("Padding")


build:
  - Scene main:
    - Box box:
      call setPadding(8, 16, 2, 8)
      call setBackgroundColor(Color("#5aa"))
      - ColorRect rect1:
        color: Color("#ff7")
        call resize(64, 64)
      - ColorRect rect2:
        color: Color("#f7f")
    - VBox vbox:
      call setPadding(2, 4, 8, 16)
      call move(100, 64)
      call setChildAnchor(1, 1, 1, 1)
      call setBackgroundColor(Color("#5aa"))
      - ColorRect rect3:
        color: Color("#ff7")
        call resize(64, 64)
      - ColorRect rect4:
        color: Color("#f7f")
    - HBox hbox:
      call setPadding(2, 4, 8, 16)
      call move(200, 64)
      call setChildAnchor(1, 1, 1, 1)
      call setBackgroundColor(Color("#5aa"))
      - ColorRect rect5:
        color: Color("#ff7")
        call resize(64, 64)
      - ColorRect rect6:
        color: Color("#f7f")
    - Label text:
      call setText("Hello, world!")
      call setBackgroundColor(Color("#324"))
      call resize(0, 0)
      call setPadding(8, 8, 8, 8)
      call move(32, 200)


addMainScene(main)
windowLaunch()
