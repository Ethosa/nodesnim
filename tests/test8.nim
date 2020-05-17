# --- Test 8. Use TextureRect node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  texturerectobj: TextureRectObj
  texturerect = TextureRect(texturerectobj)

main.addChild(texturerect)

texturerect.loadTexture("assets/sharp.jpg")  # Load image from file.
texturerect.resize(256, 256)
texturerect.texture_mode = TEXTURE_CROP
texturerect.texture_anchor = Anchor(0.5, 1, 0.5, 1)


addScene(main)
setMainScene("Main")
windowLaunch()
