import
  nodesnim


var
  editor_scene* = Scene("Editor")

  editor_holder = VBox()
  project_title = Label()


editor_holder.setSizeAnchor(1, 1)
editor_holder.setBackgroundColor(Color(0xFF352148'u32))
editor_holder.setChildAnchor(0.0, 0.0, 0.0, 0.0)
project_title.setTextAlign(0.5, 0.5, 0.5, 0.5)
project_title.setAnchor(0.5, 0.1, 0.5, 0.1)
project_title.setSizeAnchor(1.0, 0.05)


proc init* =
  discard

editor_scene@on_enter(self):
  project_title.setText(editor_scene.data[0].v)
  echo editor_scene.data[0].v


editor_scene.addChild(editor_holder)
editor_holder.addChild(project_title)
