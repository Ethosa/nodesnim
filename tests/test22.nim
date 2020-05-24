# --- Test 22. Use Slider node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  sliderobj: SliderObj
  slider = Slider(sliderobj)

main.addChild(slider)


addScene(main)
setMainScene("Main")
windowLaunch()
