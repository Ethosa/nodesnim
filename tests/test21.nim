# --- Test 21. Use ProgressBar node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  progressbarobj: ProgressBarObj
  progressbar = ProgressBar(progressbarobj)

main.addChild(progressbar)

progressbar.setProgress(50)  # default max progress value is 100.
progressbar.setMaxValue(150)


addScene(main)
setMainScene("Main")
windowLaunch()
