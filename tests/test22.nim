# --- Test 22. Use Slider node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  sliderobj: SliderObj
  slider = Slider(sliderobj)

  vsliderobj: VSliderObj
  vslider = VSlider(vsliderobj)

main.addChild(slider)
main.addChild(vslider)
vslider.move(64, 64)
vslider.setMaxValue(4)
slider.resize(256, 32)
slider.setMaxValue(1000)

vslider.on_changed =
  proc(self: VSliderPtr, v: uint) =
    if v > 2:
      vslider.setProgressColor(Color(0xccaaffff'u32))
    else:
      vslider.setProgressColor(Color(0xffaaccff'u32))

slider.on_changed =
  proc(self: SliderPtr, v: uint) =
    slider.setProgressColor(Color(
      1f - v.float / slider.max_value.float, v.float / slider.max_value.float, 0
    ))


addScene(main)
setMainScene("Main")
windowLaunch()
