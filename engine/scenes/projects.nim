# author: Ethosa
import
  os,
  nodesnim


var
  projects_scene* = Scene("Projects")

  scroll_box* = Scroll()
  projects_box* = VBox()
  project_template* = ColorRect("Project")
  project_template_title* = Label("Title")
  project_template_icon* = TextureRect("Icon")

  default_icon*: GlTextureObj



projects_scene.addChild(scroll_box)

scroll_box.addChild(projects_box)
scroll_box.setBackgroundColor(Color(0x1d242aff))

projects_box.setChildAnchor(0, 0, 0, 0)
projects_box.resize(720, 480)
projects_box.separator = 0

project_template.resize(10, 48)
project_template.setSizeAnchor(1, 0)
project_template.addChilds(project_template_title, project_template_icon)

project_template_title.setText("Template title")
project_template_title.setTextColor(Color(0xf2f2f7ff'u32))
project_template_title.move(-2, 2)
project_template_title.resize(128, 20)
project_template_title.setSizeAnchor(1, 0)
project_template_title.setTextAlign(1, 0, 1, 0)
project_template_title.mousemode = MOUSEMODE_IGNORE
project_template_title.setFont(GLUT_BITMAP_HELVETICA_18, 18)

project_template_icon.resize(42, 42)
project_template_icon.move(3, 3)
project_template_icon.texture_mode = TEXTURE_KEEP_ASPECT_RATIO



scroll_box@on_process(self):
  scroll_box.viewport_w = projects_scene.rect_size.x
  scroll_box.viewport_h = projects_scene.rect_size.y
  scroll_box.rect_size.x = scroll_box.viewport_w
  projects_box.rect_size.x = projects_scene.rect_size.x
  if scroll_box.rect_size.y < scroll_box.viewport_h:
    scroll_box.rect_size.y = scroll_box.viewport_h
  for child in scroll_box.getChildIter():
    child.calcPositionAnchor()

project_template@on_process(self):
  var s = self.ColorRectRef
  if s.pressed and s.focused:
    s.color = Color(0x4e606eff)
  elif s.hovered and not mouse_pressed:
    s.color = Color(0x3a4652ff)
  else:
    s.color = Color(0x1d242aff)



proc init* =
  default_icon = load("assets/project_default_icon.jpg")

proc addNewProject*(name: string) =
  if not existsDir(nodesnim_folder / name):
    # files and folders
    createDir(nodesnim_folder / name)
    createDir(nodesnim_folder / name / "assets")
    copyFile("assets/project_default_icon.jpg", nodesnim_folder / name / "icon.jpg")
    var readme = open(nodesnim_folder / name / "README.md", fmWrite)
    readme.write("# " & name)
    readme.close()
    var gitignore = open(nodesnim_folder / name / ".gitignore", fmWrite)
    gitignore.write("nimcache/\nnimblecache/\nhtmldocs/\n\n*.exe\n*.log")
    gitignore.close()

    var new_project = project_template.duplicate()
    new_project.name = name
    new_project.getNode("Title").LabelRef.setText(name)
    new_project.getNode("Icon").TextureRectRef.setTexture(default_icon)
    projects_box.addChild(new_project)

proc loadProject*(name: string) =
  var
    new_project = project_template.duplicate()
    project_icon = load(nodesnim_folder / name / "icon.jpg")
  new_project.name = name
  new_project.getNode("Title").LabelRef.setText(name)
  new_project.getNode("Icon").TextureRectRef.setTexture(project_icon)
  projects_box.addChild(new_project)

proc loadProjects* =
  for kind, path in walkDir(nodesnim_folder):
    if existsDir(path) and path != nodesnim_folder / "saves":
      loadProject(path.lastPathPart())

proc hasProject*(name: string): bool =
  existsDir(nodesnim_folder / name)
