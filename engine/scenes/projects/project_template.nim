# author: Ethosa
import nodesnim

build:
  - ColorRect (project):
    call rename("Project")
    call setSizeAnchor(1, 0)
    - TextureRect project_template_icon:
      call rename("Icon")
      call resize(42, 42)
      texture_mode: TEXTURE_KEEP_ASPECT_RATIO
    - Label project_template_title:
      call rename("Title")
      call setTextColor(Color(0xf2f2f7ff'u32))
      call move(-2, -2)
      call resize(256, 20)
      call setTextAlign(1, 0, 1, 0)
      call setFont(GLUT_BITMAP_HELVETICA_18, 18)
      mousemode: MOUSEMODE_IGNORE

project@on_process(self):
  var s = self.ColorRectRef
  if s.pressed and s.focused:
    s.color = Color(0x4e606eff)
  elif s.hovered and not mouse_pressed:
    s.color = Color(0x3a4652ff)
  else:
    s.color = Color(0x1d242aff)

project@on_click(self, x, y):
  changeScene("Editor", @[(k: "title", v: self.getNode("Title").LabelRef.text)])
  glutReshapeWindow(1280, 720)
