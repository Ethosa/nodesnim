import
  macros


proc addNode(level: var seq[NimNode], code: NimNode): NimNode {.compileTime.} =
  result = newStmtList()
  if code.kind in [nnkStmtList, nnkObjConstr]:
    for line in code.children():
      if line.kind == nnkPrefix:
        if line[0].kind == nnkIdent and line[1].kind == nnkCommand:
          if $line[0] == "-":
            if line[1][1].kind == nnkIdent:
              result.add(newVarStmt(line[1][1], newCall($line[1][0], newStrLitNode($line[1][1]))))
            elif line[1][1].kind == nnkObjConstr:
              result.add(newVarStmt(line[1][1][0], newCall($line[1][0], newStrLitNode($line[1][1][0]))))
            elif line[1][1].kind == nnkPar:
              result.add(newVarStmt(postfix(line[1][1][0], "*"), newCall($line[1][0], newStrLitNode($line[1][1][0]))))
            if level.len() > 0:
              # - Scene main_scene:
              if line[1][1].kind == nnkIdent:
                result.add(newCall("addChild", level[^1], line[1][1]))
              elif line[1][1].kind == nnkPar:
                result.add(newCall("addChild", level[^1], line[1][1][0]))
              elif line[1][1].kind == nnkObjConstr:
                result.add(newCall("addChild", level[^1], line[1][1][0]))
                level.add(line[1][1][0])
                var nodes = addNode(level, line[1][1])
                for i in nodes.children():
                  result.add(i)
      # call methodName(arg1, arg2) -> currentNode.methodName(arg1, arg2)
      elif line.kind == nnkCommand and $line[0] == "call" and level.len() > 0:
        line[1].insert(1, level[^1])
        result.add(line[1])
      # property: value -> currentNode.property = value
      elif line.kind in [nnkCall, nnkExprColonExpr] and level.len() > 0:
        var attr = newNimNode(nnkAsgn)
        attr.add(newNimNode(nnkDotExpr))
        attr[0].add(level[^1])
        attr[0].add(line[0])
        attr.add(line[1])
        result.add(attr)
      if len(line) == 3 and line[2].kind == nnkStmtList and line[1].kind == nnkCommand:
        level.add(line[1][1])
        var nodes = addNode(level, line[2])
        for i in nodes.children():
          result.add(i)
    if level.len() > 0:
      discard level.pop()


macro build*(code: untyped): untyped =
  ## Builds nodes with YML-like syntax.
  ##
  ## Example:
  ## .. code-block:: nim
  ##
  ##   build:
  ##     - Scene scene:
  ##       Node test_node
  ##       Node node
  result = newStmtList()
  var
    current_level: seq[NimNode] = @[]
    nodes = addNode(current_level, code)
  for i in nodes.children():
    result.add(i)
