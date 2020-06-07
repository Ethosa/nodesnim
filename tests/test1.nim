# --- Test 1. Create a window and set up the main scene. --- #
import nodesnim


Window(
  "hello world",  # Window name
  640,            # Window width,
  360             # Window height
)

var main = Scene("Main")  # Create a new Scene object.


addScene(main)        # Add new scene in window.
setMainScene("Main")  # Set main scene.
windowLaunch()        # Start main loop.
