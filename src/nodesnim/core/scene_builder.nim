import
  macros


proc addNode(level: var seq[NimNode], code: NimNode): NimNode {.compileTime.} =
  result = newStmtList()
  if code.kind in [nnkStmtList, nnkObjConstr, nnkCall]:
    for line in code.children():
      if line.kind == nnkPrefix and line[0].kind == nnkIdent and line[1].kind == nnkCommand:
        # - Node name:
        if $line[0] == "-":
          case line[1][1].kind
          of nnkIdent:  # - Node name:
            result.add(newVarStmt(line[1][1], newCall($line[1][0], newStrLitNode($line[1][1]))))
          of nnkObjConstr:  # - Node name(a: .., b: ...)
            result.add(newVarStmt(line[1][1][0], newCall($line[1][0], newStrLitNode($line[1][1][0]))))
          of nnkPar:  # Node (name):
            result.add(newVarStmt(postfix(line[1][1][0], "*"), newCall($line[1][0], newStrLitNode($line[1][1][0]))))
          of nnkCall:  # Node name(call smth()):
            result.add(newVarStmt(line[1][1][0], newCall($line[1][0], newStrLitNode($line[1][1][0]))))
          else:
            discard

          if level.len() > 0:
            case line[1][1].kind:
            of nnkIdent:
              result.add(newCall("addChild", level[^1], line[1][1]))
            of nnkPar, nnkObjConstr, nnkCall:
              result.add(newCall("addChild", level[^1], line[1][1][0]))
            else:
              discard

          if line[1][1].kind == nnkObjConstr:  # - Node node(...)
            level.add(line[1][1][0])
            let nodes = addNode(level, line[1][1])
            for i in nodes.children():
              result.add(i)
      # call methodName(arg1, arg2) -> currentNode.methodName(arg1, arg2)
      elif line.kind == nnkCommand and $line[0] == "call" and level.len > 0:
        line[1].insert(1, level[^1])
        result.add(line[1])
      # @onProcess() -> parent@onProcess(self)
      # @onPress(x, y) -> parent@onPress(self, x, y)
      elif line.kind == nnkCall and line[0].kind == nnkPrefix and level.len > 0:
        if $line[0][0] == "@":
          var tmp = newCall(line[0][1], ident"self")
          for arg in 1..line.len-2:
            tmp.add(line[arg])
          result.add(newCall("@", level[^1], tmp, line[^1]))
      # property: value -> currentNode.property = value
      elif line.kind in [nnkCall, nnkExprColonExpr] and level.len > 0:
        let attr = newNimNode(nnkAsgn)
        attr.add(newNimNode(nnkDotExpr))
        attr[0].add(level[^1])
        attr[0].add(line[0])
        attr.add(line[1])
        result.add(attr)

      if line.len == 3 and line[2].kind == nnkStmtList and line[1].kind == nnkCommand:
        case line[1][1].kind
        of nnkIdent:
          level.add(line[1][1])
        of nnkObjConstr:
          level.add(line[1][1][0])
        else:
          discard
        let nodes = addNode(level, line[2])
        for i in nodes.children():
          result.add(i)

      elif line.len == 2 and line[1].kind == nnkCommand and line[1][1].kind == nnkCall:
        level.add(line[1][1][0])
        let nodes = addNode(level, line[1][1])
        for i in nodes.children():
          result.add(i)
    if level.len > 0:
      discard level.pop()


macro build*(code: untyped): untyped =
  ## Builds nodes with YML-like syntax.
  ##
  ## Example:
  ## .. code-block:: nim
  ##
  ##   build:
  ##     - Scene scene:
  ##       - Node test_node
  ##       - Label text:
  ##         call setText("Hello, world!")
  ##       - Button btn(call setText(""))
  result = newStmtList()
  var
    current_level: seq[NimNode] = @[]
    nodes = addNode(current_level, code)
  for i in nodes.children():
    result.add(i)
