# --- Test 43. Use AnimationPlayer. --- #
import nodesnim

Window("AnimationPlayer")

build:
  - Scene scene:
    - ColorRect rect:
      color: Color(0, 0, 0)
      call resize(100, 100)
    - AnimationPlayer animation:
      call addState(rect.color.r.addr, @[(tick: 0, value: 0.0), (tick: 200, value: 1.0)])
      call addState(rect.position.x.addr, @[(tick: 0, value: 0.0), (tick: 50, value: 50.0), (tick: 200, value: 100.0)])
      call setDuration(200)
      call play()

addMainScene(scene)
windowLaunch()
