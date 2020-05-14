# --- Test 12. Label node. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  labelobj: LabelObj
  label = Label(labelobj)

main_scene.addChild(label)

label.resize(256, 256)
# You can change label text
label.text = "Hello, world"
# `color` is the font color.
label.color = Color(1, 0.6, 1)
# `background_color` is the background color ... :)
label.background_color = Color(1, 0.6, 1, 0.4)
# You can set text align inside the Label.
label.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
# You can also do not set your font, as nodesnim has a default font.
label.fontdata = openFont("assets/GNUUnifont9FullHintInstrUCSUR.ttf", 16)


window.setMainScene(main_scene)
window.launch()
