# --- Test 1. Work with Window.. --- #
import
  nodesnim,
  unittest


suite "Work with Window":

  test "Create window":
    # Window(title, width, height)
    Window(title = "MyWindow",
           w = 720, h = 480)

  test "Change Window title":
    setTitle("My own window ^^")

  test "Change Window icon":
    setIcon("assets/sharp.jpg")

  test "Resize and centered window":
    resizeWindow(1024, 640)
    centeredWindow()

  test "Setup environment":
    env.color = Color(1, 0.6, 1)  # window background color.
    env.delay = 1000 div 120  # 120 frames per second.

  test "Setup window":
    build:  # Node builder
      - Scene main  # Create an empty Scene node with the name "main".

    test "Register events":
      addKeyAction("forward", "w")
      addKeyAction("backward", "s")

    test "Handle events":
      main@onProcess(self):
        if isActionJustPressed("forward"):
          echo "forward pressed!"
        elif isActionJustPressed("backward"):
          echo "backward pressed!"

    addMainScene(main)  # Adds scene to window and 
    windowLaunch()
