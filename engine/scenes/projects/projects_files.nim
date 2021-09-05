import
  os,
  nodesnim,
  project_template,
  main

proc addProject(name: string, icon: GlTextureObj) =
  var new_project = project_template.project.duplicate()
  new_project.name = name
  new_project.getNode("Title").LabelRef.setText(name)
  new_project.getNode("Icon").TextureRectRef.setTexture(icon)
  projects_box.addChild(new_project)

proc addNewProject*(name: string) =
  if not dirExists(nodesnim_folder / name):
    # files and folders
    createDir(nodesnim_folder / name)
    createDir(nodesnim_folder / name / "assets")
    createDir(nodesnim_folder / name / ".nodesnim")
    copyFile(node_image, nodesnim_folder / name / "icon.jpg")
    let readme = open(nodesnim_folder / name / "README.md", fmWrite)
    readme.write("# " & name)
    readme.close()
    let gitignore = open(nodesnim_folder / name / ".gitignore", fmWrite)
    gitignore.write("nimcache/\nnimblecache/\nhtmldocs/\n\n*.exe\n*.log")
    gitignore.close()

    addProject(name, default_icon)

proc loadProjects* =
  for kind, path in walkDir(nodesnim_folder):
    if dirExists(path) and dirExists(path / ".nodesnim"):
      addProject(path.lastPathPart(), load(path / "icon.jpg", GL_RGBA))

proc hasProject*(name: string): bool =
  dirExists(nodesnim_folder / name)