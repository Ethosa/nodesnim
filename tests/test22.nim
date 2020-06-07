# --- Test 22. Use Slider node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  slider = Slider()
  vslider = VSlider()

main.addChild(slider)
main.addChild(vslider)
vslider.move(64, 64)
vslider.setMaxValue(4)
slider.resize(256, 32)
slider.setMaxValue(1000)

vslider.on_changed =
  proc(self: VSliderRef, v: uint) =
    if v > 2:
      vslider.setProgressColor(Color(0xccaaffff'u32))
    else:
      vslider.setProgressColor(Color(0xffaaccff'u32))

slider.on_changed =
  proc(self: SliderRef, v: uint) =
    slider.setProgressColor(Color(
      1f - v.float / slider.max_value.float, v.float / slider.max_value.float, 0
    ))


addScene(main)
setMainScene("Main")
windowLaunch()
