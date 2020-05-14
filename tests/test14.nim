# --- Test 14. Use TextureRect node. --- #
import nodesnim


var
  window = newWindow("hello world", 640, 360)
  main: SceneObj
  main_scene = Scene("Main", main)

  textureobj: TextureRectObj
  texture = TextureRect(textureobj)

main_scene.addChild(texture)

texture.resize(256, 256)
texture.move(128, 32)
texture.texture_mode = TEXTURE_KEEP_ASPECT_RATIO  # Can be `TEXTURE_CROP`, `TEXTURE_KEEP_ASPECT_RATIO` or `TEXTURE_FULL_SIZE`.
# Try to change texture_mode :з
texture.texture = Image.load("assets/sharp.jpg")  # Loads image.
texture.texture_anchor = Anchor(0, 0, 0, 0)  # texture anchor, try change it :з
texture.keep_in = true
# the `keep_in` property indicates whether to trim the texture to the size of the` TextureRect`.

window.setMainScene(main_scene)
window.launch()
