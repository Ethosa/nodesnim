# --- Test 4. Work with core. --- #
import
  nodesnim,
  unittest


suite "Work with core":
  test "Anchor":
    var anchor = Anchor(1, 0.5, 1, 0.5)
    echo anchor

  test "Color":
    var
      clr1 = Color(255, 100, 155, 1f)  # RGBA
      clr2 = Color(255, 100, 155, 255)
      clr3 = Color(0xAACCFFFF'u32)
      clr4 = Color("#AACCFFFF")
      clr5 = Color("rgb(255, 100, 155)")
      clr6 = Color("#acf")
    assert clr1 == clr2
    assert clr1 == clr5
    assert clr3 == clr4
    assert clr3 == clr6

  test "Vector2":
    var
      vec1 = Vector2()
      vec2 = Vector2(0, 0)
      vec3 = Vector2(1, 2).normalized()
    assert vec1 == vec2
    echo vec3

  test "stylesheet":
    var
      s = style({
          nums: 0 0 0 0 0 0 0 1,
          clr: rgba(255, 100, 255, 0.1),
          padding: 0 0 0 0,
          background-color: "#fff"
        })
    echo s
