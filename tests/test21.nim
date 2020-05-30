# --- Test 21. Use ProgressBar node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main", mainobj)

  progressbar = ProgressBar()

  vprogressbar = VProgressBar()

main.addChild(progressbar)
main.addChild(vprogressbar)

progressbar.setProgress(50)  # default max progress value is 100.
progressbar.setMaxValue(150)

vprogressbar.setProgress(2)  # default max progress value is 100.
vprogressbar.setMaxValue(5)
vprogressbar.move(0, 64)


addScene(main)
setMainScene("Main")
windowLaunch()
