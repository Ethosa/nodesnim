# author: Ethosa
import
  color,
  exceptions,
  tables,
  macros


type
  Colors = Table[string, ColorRef]
  ThemeRef* = ref object
    name*: string
    colors*: Colors


proc newTheme*(name: string, colors: Colors): ThemeRef =
  ThemeRef(name: name, colors: colors)


var
  themes = @[
    newTheme("default", {
             "background" : Color("#181527"),
             "background_deep" : Color("#131022"),
             "accent" : Color("#cb8ea3"),
             "accent_dark" : Color("#9a4488"),
             "foreground" : Color("#d8d3ec"),
             "url_color": Color("#582af2")}.toTable()),
    newTheme("light", {
             "background": Color("#fbd6b3"),
             "background_deep": Color("#cbb693"),
             "accent": Color("#fbaefa"),
             "accent_dark": Color("#da9de9"),
             "foreground": Color("#39414b"),
             "url_color": Color("#2a9afc")}.toTable())
  ]
{.cast(noSideEffect).}:
  var current_theme* = themes[0].deepCopy()

proc addTheme*(theme: ThemeRef) =
  themes.add(theme)

proc getTheme*(name: string): ThemeRef =
  for theme in themes:
    if theme.name == name:
      return theme
  throwError(ResourceError, "Theme " & name & " isn't available.")

proc `[]`*(theme: ThemeRef, index: string): ColorRef =
  ## Returns theme color by name.
  for name, clr in theme.colors.pairs():
    if name == index:
      return clr

proc changeTheme*(name: string) =
  ## Changes color theme to another, if available.
  var theme = getTheme(name)
  current_theme.name = theme.name
  for name, clr in theme.colors.pairs():
    theme.colors[name].copyColorTo(current_theme.colors[name])

macro `~`*(theme: ThemeRef, field: untyped): untyped =
  ## Alternative usage of `[]` proc.
  ##
  let fname = $field
  result = quote do:
    `theme`[`fname`]
