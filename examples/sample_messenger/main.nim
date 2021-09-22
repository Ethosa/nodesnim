# --- Sample messenger example --- #
import
  nodesnim,
  scenes/enter,
  scenes/chat


when isMainModule:
  Window("Client", 320, 640)


  addScene(chat_scene)
  addMainScene(enter_scene)
  windowLaunch()
