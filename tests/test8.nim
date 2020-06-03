# --- Test 8. Use TextureRect node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  texturerectobj: TextureRectObj
  texturerect = TextureRect(texturerectobj)

main.addChild(texturerect)

var texture = load("assets/sharp.jpg")  # Load image from file.
texturerect.setTexture(texture)
texturerect.resize(256, 256)
texturerect.setBackgroundColor(Color(1, 0.6, 1, 0.6))
texturerect.setTextureFilter(Color(1f, 1f, 1f))
texturerect.texture_mode = TEXTURE_KEEP_ASPECT_RATIO  # Can be also TEXTURE_CROP or TEXTURE_FILL_XY
texturerect.texture_anchor = Anchor(0.5, 1, 0.5, 1)


addScene(main)
setMainScene("Main")
windowLaunch()
