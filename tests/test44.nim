# --- Test 44. Use CheckBox node. --- #
import nodesnim


Window("drawable oops")

build:
  - Scene scene:
    - CheckBox box:
      call setText("smth checkbox")
      call enable()
    - ColorRect rect:
      call move(100, 100)

box@on_toggle(self, value):
  if value:
    rect.color.a = 1f
  else:
    rect.color.a = 0f


addMainScene(scene)
windowLaunch()
