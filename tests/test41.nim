# --- Test 41. Use StyleSheet object. --- #
import nodesnim


var mystyle = style(
  {
    background-color: rgba(255, 125, 255, 0.7),
    color: rgb(34, 34, 34),
    font-size: 1,
    text-align: center
  })
echo mystyle

var background = Color(mystyle["background-color"])

assert background == Color(255, 125, 255, 0.7)

echo StyleSheet(
  {
    "background-color": "#f2f2f7"
  }
)
