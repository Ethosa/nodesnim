# --- Test 13. Clicker. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  labelobj: LabelObj
  label = Label(labelobj)

  controlobj: ControlObj
  control = Control(controlobj)
  score = 0

main_scene.addChild(control)
control.addChild(label)

# --- Set up label and control. --- #
label.resize(128, 64)
label.text = "Press me :3"
label.color = Color(1, 0.6, 1)
label.background_color = Color(1, 0.6, 1, 0.4)
label.text_align = Anchor(0.5, 0.5, 0.5, 0.5)
label.fontdata = openFont("assets/GNUUnifont9FullHintInstrUCSUR.ttf", 16)

control.resize(640, 360)
label.anchor = Anchor(0.5, 0.5, 0.5, 0.5)

# --- Set up actions. --- #
label.mouse_enter =
  proc(x, y: float) =
    if not label.pressed:
      label.background_color.a = 0.5
label.mouse_exit =
  proc() =
    if not label.pressed:
      label.background_color.a = 0.4

label.press =
  proc(x, y: float) =
    label.background_color.a = 0.6
label.release =
  proc() =
    if label.hovered:
      label.background_color.a = 0.5
    else:
      label.background_color.a = 0.4
    inc score
    label.text = "Score: " & $score



window.setMainScene(main_scene)
window.launch()
