# --- Test 19. Use ProgressBar node. --- #
import nodesnim


Window("hello world")

var
  main = Scene("Main")

  progressbar = ProgressBar()
  vprogressbar = ProgressBar()
  cprogressbar = ProgressBar()

vprogressbar.progress_type = PROGRESS_BAR_VERTICAL
cprogressbar.progress_type = PROGRESS_BAR_CIRCLE


main.addChild(progressbar)
main.addChild(vprogressbar)
main.addChild(cprogressbar)

progressbar.setProgress(50)  # default max progress value is 100.
progressbar.setMaxValue(150)

vprogressbar.setProgress(2)  # default max progress value is 100.
vprogressbar.setMaxValue(5)
vprogressbar.move(0, 64)
vprogressbar.resize(20, 80)

cprogressbar.move(64, 64)
cprogressbar.resize(80, 80)
cprogressbar.indeterminate = true
cprogressbar.setMaxValue(15)
cprogressbar.setProgress(5)


addScene(main)
setMainScene("Main")
windowLaunch()
