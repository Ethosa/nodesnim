# author: Ethosa
import
  nodesnim,
  scenes/projects


Window("NodesNim engine", 720, 480)

projects.init()


if not hasProject("Hello, world!"):
  addNewProject("Hello, world!")
else:
  loadProjects()


addMainScene(projects_scene)
windowLaunch()
