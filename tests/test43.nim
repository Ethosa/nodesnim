# --- Test 43. Use AnimationPlayer. --- #
import nodesnim

Window("AnimationPlayer")

build:
  - Scene scene:
    - ColorRect rect:
      color: Color(0, 0, 0)
      call resize(100, 100)
    - ColorRect rect1:
      color: Color(0, 0, 0)
      call resize(100, 100)
      call move(0, 200)
    - AnimationPlayer animation:
      call addState(rect.color.r.addr, @[(tick: 0, value: 0.0), (tick: 200, value: 1.0)])
      call addState(rect.position.x.addr, @[(tick: 0, value: 0.0), (tick: 100, value: 250.0)])
      call setDuration(200)
      call play()
      mode: ANIMATION_NORMAL  # Default animation mode.
    - AnimationPlayer animation1:
      call addState(rect1.position.x.addr, @[(tick: 0, value: 0.0), (tick: 100, value: 250.0)])
      call setDuration(200)
      call play()
      mode: ANIMATION_EASE

addMainScene(scene)
windowLaunch()
