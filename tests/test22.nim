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


addScene(main)
setMainScene("Main")
windowLaunch()
