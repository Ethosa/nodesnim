# author: Ethosa
import nodesnim


Window("SceneBuilder")


build:
  # Create node.
  # var main = Scene(name = "main")
  - Scene main:
    # Create node with params.
    # var rect = ColorRect(name = "rect")
    # rect.color = Color(0.6, 0.5, 1)
    - ColorRect rect(color: Color(0.6, 0.5, 1)):
      # handle Mouse press event.
      # rect.on_press = proc(self: NodeRef, x, y: float) =
      @onPress(x, y):
        rect.color.r -= 0.01
      # handle Mouse release event.
      # rect.on_release = proc(self: NodeRef, x, y: float) =
      @onRelease(x, y):
        rect.color.r = 0.6

    # Create a new Label with params.
    # var hw = Label(name = "hw")
    # hw.anchor = Anchor(0.5, 0.5, 0.5, 0.5)
    - Label hw(anchor: Anchor(0.5, 0.5, 0.5, 0.5)):
      # Call Label method:
      # hw.setText("Hello, world!")
      call setText("Hello, world!")

    # Repeating nodes can be written briefly:
    - Node node0(is_ready: true, call hide())
    - Node2D node1(is_ready: true, call hide())
    - Node3D node2(is_ready: true, call hide())
    - Control node3(is_ready: true, call hide())


addMainScene(main)
windowLaunch()
