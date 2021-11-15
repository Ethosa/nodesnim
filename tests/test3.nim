# --- Test 3. Work with Control nodes. --- #
import
  nodesnim,
  unittest


suite "Work with Control nodes.":
  
  test "Setup window":
    Window("Control test", 1280, 640)


  test "Setup scenes":
    build:
      - Scene main
      - Scene second_scene
    addMainScene(main)
    addScene(second_scene)


  test "Register events":
    addButtonAction("click", BUTTON_LEFT)
    addKeyAction("space", K_SPACE)
    addKeyAction("enter", 13)


  test "Control test":
    build:
      - Control control
    getSceneByName("main").addChild(control)


  test "ColorRect test":
    build:
      - ColorRect rect:
        color: Color(1, 0.8, 0.95, 0.8)

    test "Handle Control events":
      rect@onFocus(self):
        echo "focused"
      rect@onUnfocus(self):
        echo "unfocused"

      rect@onClick(self, x, y):
        echo "clicked in (", x, ", ", y, ")"
      rect@onRelease(self, x, y):
        echo "released in (", x, ", ", y, ")"
        rect.color.r = 1f
      rect@onPress(self, x, y):
        rect.color.r -= 0.01

      rect@onMouseEnter(self, x, y):
        rect.color.g = 0.5f
      rect@onMouseExit(self, x, y):
        rect.color.g = 0.8f

    getSceneByName("main").addChild(rect)


  test "Anchor settings test":
    build:
      - ColorRect rect1:
        color: Color(0.2, 0.3, 0.4)
        call move(40, 0)
        call resize(80, 80)
        - ColorRect rect2:
          color: Color(0.4, 0.3, 0.2)
          call setSizeAnchor(0.25, 0.5)
          call setAnchor(1, 1, 1, 1)  # anchor to bottom-right
    getSceneByName("main").addChild(rect1)


  test "Change scenes test":  # Press Space to change scene
    getSceneByName("main")@onProcess(self):
      if isActionJustPressed("space"):
        changeScene("second_scene")
    getSceneByName("second_scene")@onProcess(self):
      if isActionJustPressed("space"):
        changeScene("main")


  test "TextureRect test":
    build:
      - TextureRect texturerect1:
        texture_mode: TEXTURE_KEEP_ASPECT_RATIO
        texture_anchor: Anchor(0.5, 0.5, 0.5, 0.5)
        call setTexture(load("assets/sharp.jpg"))
        call resize(100, 100)
        call move(120, 0)
      - TextureRect texturerect2:
        texture_mode: TEXTURE_CROP
        texture_anchor: Anchor(0.5, 0.5, 0.5, 0.5)
        call setTexture(load("assets/sharp.jpg"))
        call resize(100, 100)
        call move(220, 0)
      - TextureRect texturerect3:
        texture_mode: TEXTURE_FILL_XY
        call setTexture(load("assets/sharp.jpg"))
        call resize(100, 100)
        call move(320, 0)
    getSceneByName("main").addChildren(texturerect1, texturerect2, texturerect3)


  test "Label test":
    build:
      - Label label:
        call setText("hello,\nworld!\n    VK!")
        call move(0, 40)
    label.text.setColor(6, 12, Color("#664fff"))
    label.text.setURL(18, 19, "https://vk.com")
    label.text.setUnderline(0, 2, true)
    label.text.setStrikethrough(1, 3, true)
    label.text.setItalic(0, true)
    getSceneByName("main").addChild(label)


  test "Button test":
    build:
      - Button btn:
        call setText("Press me ^^")
        call resize(196, 32)
        call move(420, 0)
    btn@onTouch(self, x, y):
      echo "clicked btn!"
      echo btn.text.chars[0].color
      if current_theme.name == "default":
        changeTheme("light")
      else:
        changeTheme("default")
    getSceneByName("main").addChild(btn)


  test "Box test":
    build:
      - Box box:
        call setChildAnchor(0.5, 0.5, 0.5, 0.5)
        call setPadding(2, 4, 8, 16)
        call move(420, 30)
        call setBackgroundColor(Color(1f, 1f, 1f))
        - ColorRect first:
          color: Color(0xff6699ff'u32)
          call resize(80, 80)
        - ColorRect second:
          color: Color(0xff64ffff'u32)
          call resize(60, 60)
        - ColorRect third:
          color: Color(0xffaa00ff'u32)
    getSceneByName("main").addChild(box)


  test "HBox test":
    build:
      - HBox hbox:
        call setChildAnchor(1, 1, 1, 1)
        call setPadding(2, 4, 8, 16)
        call move(520, 30)
        call setBackgroundColor(Color(1f, 1f, 1f))
        - ColorRect first:
          color: Color(0xff6699ff'u32)
          call resize(80, 80)
        - ColorRect second:
          color: Color(0xff64ffff'u32)
          call resize(60, 60)
        - ColorRect third:
          color: Color(0xffaa00ff'u32)
    getSceneByName("main").addChild(hbox)


  test "VBox test":
    build:
      - VBox vbox:
        call setChildAnchor(1, 1, 1, 1)
        call setPadding(2, 4, 8, 16)
        call move(420, 144)
        call setBackgroundColor(Color(1f, 1f, 1f))
        - ColorRect first:
          color: Color(0xff6699ff'u32)
          call resize(80, 80)
        - ColorRect second:
          color: Color(0xff64ffff'u32)
          call resize(60, 60)
        - ColorRect third:
          color: Color(0xffaa00ff'u32)
    getSceneByName("main").addChild(vbox)


  test "GridBox test":
    build:
      - GridBox grid:
        call setPadding(2, 4, 8, 16)
        call move(530, 144)
        call setRow(3)
        call setBackgroundColor(Color(1f, 1f, 1f))
        - ColorRect first(color: Color(0xff6699ff'u32))
        - ColorRect second(color: Color(0xff64ffff'u32))
        - ColorRect third(color: Color(0xffaa00ff'u32))
        - ColorRect fourth(color: Color(0xffcc33ff'u32))
        - ColorRect fifth(color: Color(0xffcc66ff'u32))
        - ColorRect sixth(color: Color(0xff6655ff'u32))
    getSceneByName("main").addChild(grid)


  test "EditText test":
    build:
      - EditText edit:
        call move(0, 150)
    getSceneByName("main").addChild(edit)


  test "Scroll test":
    # TODO: Fix it with glFramebuffer
    build:
      - Scroll scroll:
        call setAnchor(1, 0, 1, 0)
        - GridBox grid:
          call setPadding(2, 4, 8, 16)
          call setRow(3)
          call setBackgroundColor(Color(1f, 1f, 1f))
          - ColorRect first(color: Color(0xff6699ff'u32), rect_size: Vector2(100, 200))
          - ColorRect second(color: Color(0xff64ffff'u32))
          - ColorRect third(color: Color(0xffaa00ff'u32))
          - ColorRect fourth(color: Color(0xffcc33ff'u32))
          - ColorRect fifth(color: Color(0xffcc66ff'u32))
          - ColorRect sixth(color: Color(0xff6655ff'u32))
    getSceneByName("main").addChild(scroll)


  test "ProgressBar test":
    build:
      - ProgressBar bar1:
        progress_type: PROGRESS_BAR_HORIZONTAL
        indeterminate: true
        call setProgress(50)
        call move(120, 110)
        call resize(100, 20)
      - ProgressBar bar2:
        progress_type: PROGRESS_BAR_VERTICAL
        indeterminate: true
        call setProgress(50)
        call move(220, 100)
        call resize(20, 110)
      - ProgressBar bar3:
        progress_type: PROGRESS_BAR_CIRCLE
        indeterminate: true
        call setProgress(50)
        call move(320, 110)
        call resize(100, 100)
    getSceneByName("main").addChildren(bar1, bar2, bar3)


  test "Popup test":
    build:
      - Popup popup:
        call setAnchor(0, 1, 0, 1)
        - Label text:
          call setText("popup!")
    getSceneByName("main").getNode("control")@onProcess(self):
      if isActionJustPressed("enter"):
        popup.toggle()
    getSceneByName("main").addChild(popup)


  test "TextureButton test":
    build:
      - TextureButton button:
        call setNormalTexture(load("assets/button_normal.png", GL_RGBA))
        call setHoverTexture(load("assets/button_hover.png", GL_RGBA))
        call setPressTexture(load("assets/button_press.png", GL_RGBA))
        call resize(256, 64)
        call move(120, 220)
        call setText("Texture button")
    getSceneByName("main").addChild(button)


  test "TextureProgressBar test":
    build:
      - TextureProgressBar progress:
        call setProgressTexture(load("assets/texture_progress_1.png", GL_RGBA))
        call setBackgroundTexture(load("assets/texture_progress_0.png", GL_RGBA))
        call setProgress(50)
        call resize(256, 85)
        call move(100, 300)
    getSceneByName("main").addChild(progress)


  test "Counter test":
    build:
      - Counter counter:
        call move(360, 360)
        call setMaxValue(100)
    getSceneByName("main").addChild(counter)


  test "Switch test":
    build:
      - Switch switch:
        call move(360, 400)
    getSceneByName("main").addChild(switch)


  test "CheckBox test":
    build:
      - CheckBox check:
        call setText("smth checkbox")
        call enable()
        call move(700, 300)
    getSceneByName("main").addChild(check)


  test "SubWindow test":
    build:
      - SubWindow window1:
        call setIcon("assets/anim/0.jpg")
        call setTitle("subwindow")
        call move(500, 400)
        call open()
    getSceneByName("main").addChild(window1)


  test "Slider test":
    build:
      - Slider slider1:
        slider_type: SLIDER_HORIZONTAL
        call resize(100, 10)
        call move(600, 300)
      - Slider slider2:
        slider_type: SLIDER_VERTICAL
        call resize(10, 100)
        call move(600, 310)
    getSceneByName("main").addChildren(slider1, slider2)

  test "ToolTip test":
    build:
      - ToolTip tooltip:
        call showAtMouse()
        @onProcess():
          tooltip.showAtMouse()
    getSceneByName("main").addChild(tooltip)

  test "Line & Bar chart test":
    build:
      - Chart my_chart:
        call addChartData(
          newChartData(
            @["one", "two", "three", "four", "five", "six"],
            @[1, 8, 18, 32, 4, 16], "myData", current_theme~accent_dark, BAR_CHART))
        call addChartData(
          newChartData(
            @["one", "two", "three", "four", "five", "six"],
            @[1, 8, 18, 32, 4, 16], "myData", current_theme~accent, LINE_CHART))

        call move(100, 450)
        call resize(320, 196)

    getSceneByName("main").addChildren(my_chart)

  test "Pie chart test":
    build:
      - Chart circle_chart:
        call addChartData(
          newChartData(
            @["one", "two", "three", "four", "five", "six"],
            @[1, 8, 18, 32, 4, 16], "myData", current_theme~accent_dark, PIE_CHART))

        call move(900, 450)
        call resize(128, 128)

    getSceneByName("main").addChildren(circle_chart)

  test "Radar chart test":
    build:
      - Chart spiderweb_chart:
        call addChartData(
          newChartData(
            @["one", "two", "three", "four", "five", "six"],
            @[10, 24, 18, 32, 4, 16], "myData", current_theme~accent_dark, RADAR_CHART))

        call move(700, 450)
        call resize(128, 128)

    getSceneByName("main").addChildren(spiderweb_chart)


  test "Launch window":
    windowLaunch()
