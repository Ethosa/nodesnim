# --- Test 2. Play music. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  playerobj: MusicStreamPlayerObj
  player = MusicStreamPlayer("MusicStreamPlayer", playerobj)

main_scene.addChild(player)
player.load("assets/vug_ost_Weh.wav")  # Load music from file.
player.play()


window.setMainScene(main_scene)
window.launch()
