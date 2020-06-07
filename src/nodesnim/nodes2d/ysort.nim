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
  YSortRef* = ref YSortObj


proc YSort*(name: string = "YSort"): YSortRef =
  ## Creates a new YSort.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = YSort("YSort")
  nodepattern(YSortRef)
  node2dpattern()
  result.for_all_childs = false
  result.kind = YSORT_NODE


template childsiter() =
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
    inc i
  if child notin childs:
    childs.add(child)

method draw*(self: YSortRef, w, h: GLfloat) =
  ## this method uses in the `window.nim`.
  {.warning[LockLevel]: off.}
  self.position = self.timed_position

  if self.centered:
    self.position = self.timed_position - self.rect_size*2
  else:
    self.position = self.timed_position
  
  var childs: seq[NodeRef] = @[]

  if self.for_all_childs:
    for child in self.getChildIter():
      childsiter()
  else:
    for child in self.children:
      childsiter()
  for i in 0..childs.high:
    childs[i].z_index = i.float

method duplicate*(self: YSortRef): YSortRef {.base.} =
  ## Duplicates YSort and create a new YSort object.
  self.deepCopy()
