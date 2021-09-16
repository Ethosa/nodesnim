# --- Test 47. Use margin. --- #
import nodesnim


Window("Margin test")


build:
  - Scene main:
    - HBox box1:
      call setBackgroundColor(Color("#55c"))
      call setPadding(8, 8, 8, 8)
      call move(64, 64)
      separator: 0
      - ColorRect rect1:
        color: Color("#ee5")
        call setMargin(0, 16, 0, 0)
      - ColorRect rect2:
        color: Color("#5ee")
        call setMargin(8, 0, 32, 0)
      - ColorRect rect3:
        color: Color("#e5e")
    - VBox box2:
      call setBackgroundColor(Color("#55c"))
      call setPadding(8, 8, 8, 8)
      call move(256, 64)
      separator: 0
      - ColorRect rect4:
        color: Color("#ee5")
        call setMargin(16, 0, 0, 0)
      - ColorRect rect5:
        color: Color("#5ee")
        call setMargin(0, 8, 0, 32)
      - ColorRect rect6:
        color: Color("#e5e")


addMainScene(main)
windowLaunch()
