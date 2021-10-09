# --- Test 2. Work with default nodes. --- #
import
  nodesnim,
  unittest


suite "Work with default nodes.":
  
  test "Setup window":
    Window("default nodes test")

  test "Setup scene":
    build:
      - Scene main
    addMainScene(main)

  test "Canvas test":
    build:
      - Canvas canvas:
        call resize(256, 256)
        call fill(Color("#ffaacc"))
        call point(5, 5, Color("#64ffff"))
        call line(8, 16, 128, 64, Color("#ffff64ff"))
        call circle(0, 240, 32, Color("#aaff6456"))
        call line(200, -150, 0, 256, Color("#0e1317ff"))
        call bezier(0, 0, 256, 0, 256, 256, Color("#227"))
        call cubic_bezier(0, 0, 256, 0, 0, 256, 256, 256, Color("#272"))
        call move(74.4, 89.4)
        call text("hello!,\nworld!", 64, 64, Vector2(1, 1))
        call saveAs("assets/canvas.png")  # save result in file.
    getSceneByName("main").addChild(canvas)

  test "AudioStreamPlayer test":
    build:
      - AudioStreamPlayer audio1:
        stream: loadAudio("assets/vug_ost_Weh.ogg")
        call setVolume(64)  # 64/100
        call play()
    getSceneByName("main").addChild(audio1)

  test "Duplicate nodes":
    build:
      - Node node(name: "MyOwnNode")
    var node1 = node.duplicate()
    assert node.name == node1.name

  test "AnimationPlayer node":
    build:
      - ColorRect rect:
        color: Color(0, 0, 0)
        call resize(100, 100)
      - ColorRect rect1:
        color: Color(0, 0, 0)
        call resize(100, 100)
        call move(0, 150)
      - ColorRect rect2:
        color: Color(0.5, 0.8, 0.5)
        call resize(100, 100)
        call move(0, 300)
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
      - AnimationPlayer animation2:
        call addState(rect2.position.x.addr, @[(tick: 0, value: 0.0), (tick: 100, value: 250.0)])
        call setDuration(200)
        call play()
        mode: ANIMATION_BEZIER
        bezier: (0.8, 0.9)
    getSceneByName("main").addChildren(rect, rect1, rect2, animation, animation1, animation2)

  test "Launch window":
    windowLaunch()
