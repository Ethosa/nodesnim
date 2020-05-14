# author: Ethosa
import ../core/sdl2
import ../core/sdl2/image
{.used.}


type
  Image* = object


proc load*(img: type Image, file: cstring): SurfacePtr =
  ## Loads SurfacePtr from file.
  ##
  ## Arguments:
  ## - `file` - image path.
  result = load(file)

proc save*(img: type Image, surface: SurfacePtr, name: cstring) =
  ## Saves SurfacePtr to the PNG image file.
  savePNG(surface, name)
