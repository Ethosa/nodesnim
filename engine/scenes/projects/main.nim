# author: Ethosa
import nodesnim


var
  default_icon*: GlTextureObj

const
  node_image*: string = "assets/node.png"


build:
  - Scene (projects_scene):
    call rename("Projects")
    - Scroll scroll_box:
      call setBackgroundColor(Color(0x1d242aff))
      - VBox (projects_box):
        call setChildAnchor(0, 0, 0, 0)
        call resize(720, 480)
        separator: 0

scroll_box@on_process(self):
  scroll_box.viewport_w = projects_scene.rect_size.x
  scroll_box.viewport_h = projects_scene.rect_size.y
  scroll_box.rect_size.x = scroll_box.viewport_w
  projects_box.rect_size.x = projects_scene.rect_size.x
  if scroll_box.rect_size.y < scroll_box.viewport_h:
    scroll_box.rect_size.y = scroll_box.viewport_h
  for child in scroll_box.getChildIter():
    child.CanvasRef.calcPositionAnchor()


proc init* =
  default_icon = load(node_image, GL_RGBA)
  addScene(projects_scene)
