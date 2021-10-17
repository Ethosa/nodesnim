# author: Ethosa
## It provides runtime scripts loader.
import
  compiler / [
    astalgo, ast, vmdef, vm, options,
    modulegraphs, idents, modules,
    pathutils, llstream, passes, sem,
    condsyms
  ],

  ../core/exceptions,
  ../core/vector2,
  scripts_impl,

  os


var
  ident_cache = newIdentCache()
  cfg = newConfigRef()

once:
  let std = AbsoluteDir(getHomeDir() / ".nimble" / "lib")
  # Search .nimble/lib folder 👀
  cfg.libpath = std
  cfg.searchPaths.add(cfg.libpath)
  cfg.searchPaths.add(AbsoluteDir($std / "pure"))
  cfg.searchPaths.add(AbsoluteDir($std / "pure" / "collections"))
  cfg.searchPaths.add(AbsoluteDir($std / "core"))
  cfg.searchPaths.add(AbsoluteDir($std / "impure"))
  cfg.searchPaths.add(AbsoluteDir($std / "std"))
  cfg.implicitIncludes.add(getCurrentDir() / "scripts_api.nim")


# --- Convert default Nim types to PNode --- #
converter toNode*(x: float): PNode = newFloatNode(nkFloatLit, x)
converter toNode*(x: int): PNode = newIntNode(nkIntLit, x)
converter toNode*(x: string): PNode = newStrNode(nkStrLit, x)
converter toNode*(x: bool): PNode = x.ord.toNode()
converter toNode*(x: enum): PNode = x.ord.toNode()

converter toNode*(x: openarray[int|float|string|bool|enum]): PNode =
  result = newNode(nkBracket)
  result.sons.initialize(x.len)
  for i in x.low..x.high:
    result[i] = x[i].toNode()

converter toNode*(x: tuple | object): PNode =
  result = newTree(nkPar)
  for field in x.fields:
    result.sons.add(field.toNode())

converter toNode*(x: ref tuple | ref object): PNode =
  result = newTree(nkPar)
  if x.isNil():
    return result
  for field in x.fields:
    result.sons.add(field.toNode())


proc setupModule(self: CompiledScript) =
  self.graph.connectCallbacks()
  initDefines(cfg.symbols)
  defineSymbol(cfg.symbols, "nimscript")
  defineSymbol(cfg.symbols, "nimconfig")
  self.graph.registerPass(semPass)
  self.graph.registerPass(evalPass)


proc cleanupModule(self: CompiledScript) =
  initDefines(cfg.symbols)
  undefSymbol(cfg.symbols, "nimscript")
  undefSymbol(cfg.symbols, "nimconfig")
  clearPasses(self.graph)


proc compileScript*(file: string): CompiledScript =
  ## Compiles script with std module.
  new result
  result.filename = file
  result.graph = newModuleGraph(ident_cache, cfg)
  result.setupModule()
  result.module = makeModule(result.graph, file)

  # Create context
  incl(result.module.flags, sfMainModule)
  result.pctx = newCtx(result.module, identCache, result.graph)
  result.pctx.mode = emRepl

  # Setup context
  setupGlobalCtx(result.module, result.graph)
  registerAdditionalOps(result.pctx)

  # Compile std
  compileSystemModule(result.graph)

  # Compile module
  if not processModule(result.graph, result.module, llStreamOpen(AbsoluteFile(file), fmRead)):
    raise newException(VMError, "Failed to process `" & file & "`")

  # Cleanup
  setupGlobalCtx(nil, result.graph)
  result.cleanupModule()


proc getProc*(self: CompiledScript, routine: string): PSym =
  strTableGet(self.module.tab, getIdent(identCache, routine))

proc hasProc*(self: CompiledScript, routine: string): bool =
  ## Returns true, if `routine` available.
  not self.getProc(routine).isNil()


proc call*(self: CompiledScript, routine: string,
           args: varargs[PNode]): PNode {.discardable.} =
  ## Calls routine by name
  # Setup context
  setupGlobalCtx(self.module, self.graph)

  # Find routine
  let prc = self.getProc(routine)
  if prc.isNil():
    raise newException(VMError, "\nUnable to locate proc `" & routine & "` in `" & self.filename & "`")

  # Call routine
  result = execProc(self.pctx, prc, args)
