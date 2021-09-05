import
  nodesnim


build:
  - Scene editor_scene:
    call rename("Editor")
    - VBox editor_holder:
      call setSizeAnchor(1, 1)
      call setBackgroundColor(Color(0xFF352148'u32))
      call setChildAnchor(0.0, 0.0, 0.0, 0.0)
    - Label project_title:
      call setTextAlign(0.5, 0.5, 0.5, 0.5)
      call setAnchor(0.5, 0.1, 0.5, 0.1)
      call setSizeAnchor(1.0, 0.05)

editor_scene@on_enter(self):
  project_title.setText(editor_scene.data[0].v)
  echo editor_scene.data[0].v


proc init* =
  addScene(editor_scene)
