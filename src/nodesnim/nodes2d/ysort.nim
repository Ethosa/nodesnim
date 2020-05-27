# author: Ethosa
## Sorts children by its Y position.
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/rect2,
  ../core/anchor,
  ../core/input,
  ../core/enums,

  ../nodes/node,
  node2d


type
  YSortObj* = object of Node2DObj
    for_all_childs*: bool  # if true, sorts z_index of all childs
  YSortPtr* = ptr YSortObj


proc YSort*(name: string, variable: var YSortObj): YSortPtr =
  ## Creates a new YSort pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is a YSortObj variable.
  runnableExamples:
    var
      node_obj: YSortObj
      node = YSort("YSort", node_obj)
  nodepattern(YSortObj)
  node2dpattern()
  variable.for_all_childs = false

proc YSort*(obj: var YSortObj): YSortPtr {.inline.} =
  ## Creates a new YSort pointer with deffault node name "YSort".
  ##
  ## Arguments:
  ## - `variable` is a YSortObj variable.
  runnableExamples:
    var
      node_obj: YSortObj
      node = YSort(node_obj)
  YSort("YSort", obj)


method draw*(self: YSortPtr, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.calcGlobalPosition()

  self.position = self.timed_position

  if self.centered:
    self.position = self.timed_position - self.rect_size*2
  else:
    self.position = self.timed_position
  
  var childs: seq[NodePtr] = @[]

  if self.for_all_childs:
    for child in self.getChildIter():
      child.calcGlobalPosition()
      var i = 0
      let y = child.global_position.y + child.rect_size.y

      if childs.len() == 0:
        childs.add(child)
        continue

      for c in childs:
        if c.global_position.y + c.rect_size.y > y:
          childs.insert(child, i)
          break
        else:
          childs.add(child)
          break
        inc i
  else:
    for child in self.children:
      child.calcGlobalPosition()
      var i = 0
      let y = child.global_position.y + child.rect_size.y

      if childs.len() == 0:
        childs.add(child)
        continue

      for c in childs:
        let y1 = c.global_position.y + c.rect_size.y
        if y1 > y:
          childs.insert(child, i)
          break
        else:
          childs.add(child)
          break
        inc i
  for i in 0..childs.high:
    childs[i].z_index = i.float

