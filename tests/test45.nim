# --- Test 45. Use Drawable and Control. --- #
import nodesnim


Window("drawable oops")

build:
  - Scene scene:
    - Control ctrl


scene.addChild(ctrl)
ctrl.resize(256, 96)
ctrl.move(64, 64)
ctrl.setStyle(style(
  {
    background-color: rgb(33, 65, 87),
    border-radius: 8,
    border-width: 1,
    border-color: rgb(0, 0, 0),
    shadow: true,
    shadow-offset: 3,
    size-anchor: "0.5 0.7"
  }
))

addMainScene(scene)
windowLaunch()
