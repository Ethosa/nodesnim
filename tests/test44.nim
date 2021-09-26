# --- Test 44. Use GradientDrawable and Control. --- #
import nodesnim


Window("drawable oops")

build:
  - Scene scene:
    - Control ctrl:
      call resize(256, 256)
      call move(150, 50)

var gradient = GradientDrawable()
gradient.setCornerRadius(16)
gradient.setCornerDetail(16)
gradient.enableShadow(true)
gradient.setShadowOffset(Vector2(15, 15))
gradient.setBorderColor(Color(1.0, 0.5, 0.5, 0.1))
gradient.setBorderWidth(5)
gradient.setStyle(style({
  corner-color: "#ff7 #ff7 #f77 #f77"
  }))
ctrl.setBackground(gradient)


addMainScene(scene)
windowLaunch()
