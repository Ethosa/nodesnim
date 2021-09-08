# --- Test 27. Use TextureProgressBar node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  progressbar = TextureProgressBar()

  back = load("assets/texture_progress_0.png", GL_RGBA)
  progress = load("assets/texture_progress_1.png", GL_RGBA)

main.addChild(progressbar)

progressbar.setProgress(50)  # default max progress value is 100.
progressbar.setMaxValue(150)
progressbar.resize(256, 85)

progressbar.setProgressTexture(progress)
progressbar.setBackgroundTexture(back)


addScene(main)
setMainScene("Main")
windowLaunch()
