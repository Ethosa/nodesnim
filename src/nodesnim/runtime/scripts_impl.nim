import
  compiler / [vmdef, modulegraphs, vm, ast]


type
  CompiledScript* = ref object
    pctx*: PCtx
    graph*: ModuleGraph
    module*: PSym
    filename*: string


proc exposeScriptApi* (self: CompiledScript) =
  template expose (routine, body: untyped) {.dirty.} =
    self.pctx.registerCallback self.filename & "." & astToStr(routine),
      proc (a: VmArgs) =
        body

  expose add:
    # We need to use procs like getInt to retrieve the argument values from VmArgs
    # Instead of using the return statement we need to use setResult
    setResult(a,
      getInt(a, 0) +
      getInt(a, 1))
