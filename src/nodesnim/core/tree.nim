# author: Ethosa
## Provides working with TreeView.
import
  exceptions,
  ../thirdparty/gl,
  ../nodes/node,
  strutils

type
  TreeRef* = ref object
    parent*: TreeRef
    tree*: seq[TreeRef]
    level*: uint
    icon*: Gluint
    data*: string


proc Tree*(data: string = "", level: uint = 0): TreeRef =
  TreeRef(level: level, tree: @[], data: data, parent: nil, icon: 0'u32)


proc addTree*(tree: TreeRef, data: string = "") =
  tree.tree.add(TreeRef(level: tree.level + 1, tree: @[], data: data, parent: tree, icon: 0'u32))

proc addTree*(tree, other: TreeRef) =
  other.parent = tree
  tree.tree.add(other)

proc index*(tree: TreeRef): seq[int] =
  result = @[]
  var t = tree
  while not t.parent.isNil():
    result.add(t.parent.tree.find(t))
    t = t.parent

proc getTreeAt*(tree: TreeRef, index: openarray[int]): TreeRef =
  var t = tree
  for i in index:
    if t.tree.len() <= i:
      throwError(ValueError, "Can't get tree at " & $index)
    t = t.tree[i]
  t

proc getTreeIter*(tree: TreeRef): seq[TreeRef] =
  result = @[]
  if tree.level == 0:
    result.add(tree)
  for i in tree.tree:
    result.add(i)
    for t in i.getTreeIter():
      result.add(t)

proc toTree*(node: NodeRef, level: uint = 0): TreeRef =
  result = Tree(node.name, level)
  var lvl = level + 1
  for child in node.children:
    result.addTree(child.toTree(lvl))
  if lvl > 1:
    dec lvl

proc `$`*(tree: TreeRef): string =
  result = ""
  for t in tree.getTreeIter():
    result &= " ".repeat(t.level) & t.data & "\n"
