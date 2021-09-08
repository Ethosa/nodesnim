# author: Ethosa
import
  nodesnim,
  scenes/projects,
  scenes/editor


Window("NodesNim engine", 720, 480)

projects.init()
editor.init()

if not hasProject("Hello, world!"):
  addNewProject("Hello, world!")
else:
  loadProjects()


addMainScene(projects_scene)
windowLaunch()