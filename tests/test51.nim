# --- Use Sprite 3D node. --- #
import nodesnim


Window("Sprite 3D")

build:
  - Scene main:
    - Sprite3D sprite:
      call loadTexture("assets/anim/0.jpg", GL_RGB)
      call translateZ(2)

sprite@on_input(self, event):
  if event.isInputEventMouseMotion() and event.pressed:
    sprite.rotateX(-event.yrel)
    sprite.rotateY(-event.xrel)

addMainScene(main)
windowLaunch()
