# author: Ethosa
import
  ../thirdparty/gl,
  ../core/enums,
  ../core/vector2,
  ../core/anchor,
  ../core/input,
  ../core/font,
  ../core/color,
  ../core/themes,
  ../core/tree,
  ../graphics/drawable,
  ../nodes/node,
  ../nodes/canvas,
  ../private/templates,
  control


type
  TreeViewItemSelected* = proc(self: TreeViewRef, index: seq[int])
  TreeViewObj* = object of ControlObj
    tree*: TreeRef
    on_item_select*: TreeViewItemSelected
    use_icons*: bool
    show_lines*: bool
    level_width*: float
  TreeViewRef* = ref TreeViewObj

let
  tree_view_item_selected_handler =
    proc(self: TreeViewRef, index: seq[int]) =
      discard


proc TreeView*(name: string = "TreeView"): TreeViewRef =
  nodepattern(TreeViewRef)
  controlpattern()
  result.tree = Tree("tree")
  result.on_item_select = tree_view_item_selected_handler
  result.level_width = 30f
  result.use_icons = false
  result.show_lines = true
  result.kind = TREE_VIEW_NODE


method draw*(self: TreeViewRef, w, h: GLfloat) =
  procCall self.ControlRef.draw(w, h)
  let
    x = -w/2 + self.global_position.x
    y = h/2 - self.global_position.y
    offset = if self.use_icons:
               20f
             else:
               0f
    arr = self.tree.getTreeIter()
  var
    count = 0f
    width = 0f
    height = 0f

  glEnable(GL_TEXTURE_2D)
  for t in arr:
    let
      text = stext(t.data)
      size = text.getTextSize()
      x_offset = x + t.level.float*self.level_width
      y_offset = y - count*size.y
    text.renderTo(Vector2(x_offset + offset, y_offset), size, Anchor())

    if x_offset + offset > width:
      width = x_offset + offset
    if y_offset > height:
      height = y_offset

    glColor(current_theme~accent_dark)
    glLineWidth(1)
    if self.show_lines and not t.parent.isNil():
      let parent_index = arr.find(t.parent).float + 1
      glBegin(GL_LINE_STRIP)
      glVertex2f(x_offset, y_offset - size.y/2)
      glVertex2f(x + 10 + t.parent.level.float*self.level_width, y_offset - size.y/2)
      glVertex2f(x + 10 + t.parent.level.float*self.level_width, y - parent_index*size.y)
      glEnd()

    # TODO: fix.
    glColor4f(1, 1, 1, 1)
    if self.use_icons:
      if t.icon > 0u32:
        glBindTexture(GL_TEXTURE_2D, t.icon)
        glBegin(GL_QUADS)
        glTexCoord2f(0, 0)
        glVertex2f(x_offset, y_offset)
        glTexCoord2f(1, 0)
        glVertex2f(x_offset + size.y, y_offset)
        glTexCoord2f(1, 1)
        glVertex2f(x_offset + size.y, y_offset - size.y)
        glTexCoord2f(0, 1)
        glVertex2f(x_offset, y_offset - size.y)
        glEnd()
        glBindTexture(GL_TEXTURE_2D, 0)
    text.freeMemory()
    count += 1
  glDisable(GL_TEXTURE_2D)
  self.resize(width, height)

method handle*(self: TreeViewRef, event: InputEvent, mouse_on: var NodeRef) =
  {.warning[LockLevel]: off.}
  procCall self.ControlRef.handle(event, mouse_on)


method bindTree*(self: TreeViewRef, tree: TreeRef) {.base.} =
  self.tree = tree
