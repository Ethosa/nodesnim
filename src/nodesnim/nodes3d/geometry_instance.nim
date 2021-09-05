# author: Ethosa
import
  ../thirdparty/opengl,

  ../core/vector2,
  ../core/vector3,
  ../core/enums,
  ../core/anchor,
  ../core/input,
  ../core/color,

  ../nodes/node,
  node3d


type
  GeometryType* {.pure.} = enum
    GEOMETRY_CUBE
  GeometryInstanceObj* = object of Node3DObj
    geometry*: GeometryType
    color*: ColorRef
  GeometryInstanceRef* = ref GeometryInstanceObj


proc GeometryInstance*(name: string = "GeometryInstance"): GeometryInstanceRef =
  ## Creates a new GeometryInstance object.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = GeometryInstance("GeometryInstance")
  nodepattern(GeometryInstanceRef)
  node3dpattern()
  result.geometry = GEOMETRY_CUBE
  result.color = Color(1.0, 1.0, 1.0, 0.8)
  result.kind = GEOMETRY_INSTANCE_NODE


method draw*(self: GeometryInstanceRef, w, h: Glfloat) =
  ## This method uses in the `window.nim`.
  {.warning[LockLevel]: off.}

  glPushMatrix()
  glTranslatef(self.global_translation.x, self.global_translation.y, self.global_translation.z)
  glRotatef(self.global_rotation.x, 1, 0, 0)
  glRotatef(self.global_rotation.y, 0, 1, 0)
  glRotatef(self.global_rotation.z, 0, 0, 1)
  glScalef(self.scale.x, self.scale.y, self.scale.z)
  glColor4f(self.color.r, self.color.g, self.color.b, self.color.a)
  glEnable(GL_DEPTH_TEST)

  case self.geometry
  of GEOMETRY_CUBE:
    glBegin(GL_QUADS)
    # back
    glVertex3f(-1, -1, -1)
    glVertex3f( 1, -1, -1)
    glVertex3f( 1,  1, -1)
    glVertex3f(-1,  1, -1)

    # front
    glVertex3f(-1, -1, 1)
    glVertex3f( 1, -1, 1)
    glVertex3f( 1,  1, 1)
    glVertex3f(-1,  1, 1)

    # top
    glVertex3f(-1, -1, -1)
    glVertex3f( 1, -1, -1)
    glVertex3f( 1, -1,  1)
    glVertex3f(-1, -1,  1)

    # bottom
    glVertex3f(-1, 1, -1)
    glVertex3f( 1, 1, -1)
    glVertex3f( 1, 1,  1)
    glVertex3f(-1, 1,  1)

    # left side
    glVertex3f(-1, -1, -1)
    glVertex3f(-1, -1,  1)
    glVertex3f(-1,  1,  1)
    glVertex3f(-1,  1, -1)

    # right side
    glVertex3f(1, -1, -1)
    glVertex3f(1, -1,  1)
    glVertex3f(1,  1,  1)
    glVertex3f(1,  1, -1)
    glEnd()


  glDisable(GL_DEPTH_TEST)
  glPopMatrix()
