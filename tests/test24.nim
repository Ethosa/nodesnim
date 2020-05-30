# --- Test 24. Use AudioStreamPlayer node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  stream1 = loadAudio("assets/vug_ost_Weh.ogg")
  stream2 = loadAudio("assets/vug_ost_Movement.ogg")

  audio = AudioStreamPlayer()

  audio1 = AudioStreamPlayer()

audio.stream = stream1
audio.setVolume(64)
audio.play()

when false:  # use more than one channel
  audio1.stream = stream2
  audio1.setVolume(64)
  audio1.play()


addScene(main)
setMainScene("Main")
windowLaunch()
