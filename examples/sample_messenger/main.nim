# --- Sample messenger example --- #
import
  nodesnim,
  scenes/enter,
  scenes/chat


when isMainModule:
  Window("Client", 320, 640)

  addKeyAction("send", 13)  # Enter


  addScene(chat_scene)
  addMainScene(enter_scene)
  windowLaunch()
