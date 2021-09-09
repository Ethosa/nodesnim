# --- Test 45. Use GradientDrawable and Control. --- #
import nodesnim


Window("drawable oops")

build:
  - Scene scene:
    - Control ctrl:
      call resize(100, 150)
      call move(150, 50)

var gradient = GradientDrawable()
gradient.setCornerRadius(16)
gradient.setCornerDetail(16)
gradient.enableShadow(true)
gradient.setShadowOffset(Vector2(15, 15))
gradient.setBorderColor(Color(1.0, 0.5, 0.5, 0.1))
gradient.setBorderWidth(5)
gradient.setCornerColors((
  Color(1f, 0.5, 1f),
  Color(1f, 0.5, 1f, 0.2),
  Color(0.5, 0.75, 1f, 0.2),
  Color(0.5, 0.75, 1f),
))

ctrl.setBackground(gradient)


addMainScene(scene)
windowLaunch()
