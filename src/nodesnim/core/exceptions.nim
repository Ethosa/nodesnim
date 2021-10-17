# author: Ethosa
import logging

{.push pure, size: sizeof(int8).}
type
  ResourceError* = object of ValueError
  SceneError* = object of ValueError
  VMError* = object of ValueError
  WindowError* = object of ValueError
{.pop.}


template throwError*(err: typedesc, msg: string) =
  when defined(debug):
    error(msg)
  raise newException(err, msg)
