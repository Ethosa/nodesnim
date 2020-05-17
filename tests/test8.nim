# --- Test 8. Use TextureRect node. --- #
import nodesnim


Window("hello world")

var
  mainobj: SceneObj
  main = Scene("Main", mainobj)

  texturerectobj: TextureRectObj
  texturerect = TextureRect(texturerectobj)

main.addChild(texturerect)

texturerect.loadTexture("assets/sharp.jpg")
texturerect.resize(640, 360)


addScene(main)
setMainScene("Main")
windowLaunch()
