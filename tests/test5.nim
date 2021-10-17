# --- Test 5. Work with graphics. --- #
import
  nodesnim,
  unittest


suite "Work with graphics.":
  
  test "Setup window":
    Window("graphics test")


  test "Setup scene":
    build:
      - Scene main

    addMainScene(main)

  test "Color background":
    build:
      - Control ctrl

    ctrl.resize(256, 96)
    ctrl.move(64, 64)
    ctrl.setStyle(style(
      {
        background-color: rgb(33, 65, 87),
        border-radius: 8,
        border-width: 1,
        border-color: rgb(0, 0, 0),
        shadow: true,
        shadow-offset: 8,
        size-anchor: 0.5 0.7
      }
    ))

    getSceneByName("main").addChild(ctrl)


  test "Image background":
    build:
      - Control ctrl1:
        call move(350, 100)
        call setSizeAnchor(0.2, 0.2)

    ctrl1.background.setTexture(load("assets/sharp.jpg"))
    ctrl1.background.setCornerRadius(25)
    ctrl1.background.setCornerDetail(8)
    ctrl1.background.enableShadow(true)
    ctrl1.background.setShadowOffset(Vector2(0, 8))

    getSceneByName("main").addChild(ctrl1)


  test "Gradient background":
    build:
      - Control ctrl2:
        call resize(96, 96)
        call setAnchor(0, 0.5, 0, 0.5)
    var gradient = GradientDrawable()
    gradient.setCornerRadius(16)
    gradient.setCornerDetail(16)
    gradient.enableShadow(true)
    gradient.setShadowOffset(Vector2(15, 15))
    gradient.setBorderColor(Color(1.0, 0.5, 0.5, 0.1))
    gradient.setBorderWidth(5)
    gradient.setStyle(style({
      corner-color: "#ff7 #ff7 #f77 #f77"
      }))
    ctrl2.setBackground(gradient)

    getSceneByName("main").addChild(ctrl2)


  test "Launch window":
    windowLaunch()
