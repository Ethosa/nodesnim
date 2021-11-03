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
  node3d,
  math


type
  GeometryInstanceObj* = object of Node3DObj
    geometry*: GeometryType
    sides*, rings*: int
    color*: ColorRef
    radius*: float
  GeometryInstanceRef* = ref GeometryInstanceObj


proc GeometryInstance*(name: string = "GeometryInstance", geometry: GeometryType = GEOMETRY_CUBE): GeometryInstanceRef =
  ## Creates a new GeometryInstance object.
  ##
  ## Arguments:
  ## - `name` is a node name.
  runnableExamples:
    var node = GeometryInstance("GeometryInstance")
  nodepattern(GeometryInstanceRef)
  node3dpattern()
  result.geometry = geometry
  result.sides = 8
  result.rings = 8
  result.radius = 1
  result.color = Color(1.0, 1.0, 1.0)
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
  glColor(self.color)
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
  of GEOMETRY_CYLINDER:
    # Draw sides
    glBegin(GL_QUAD_STRIP)
    for i in 0..self.sides:
      let angle = TAU*i.float/self.sides.float
      glVertex3f(sin(angle)*self.radius, 1, cos(angle)*self.radius)
      glVertex3f(sin(angle)*self.radius, -1, cos(angle)*self.radius)
    glEnd()

    # Draw top
    glBegin(GL_POLYGON)
    for i in 0..self.sides:
      let angle = TAU*i.float/self.sides.float
      glVertex3f(sin(angle)*self.radius, 1, cos(angle)*self.radius)
    glEnd()

    # Draw bottom
    glBegin(GL_POLYGON)
    for i in 0..self.sides:
      let angle = TAU*i.float/self.sides.float
      glVertex3f(sin(angle)*self.radius, -1, cos(angle)*self.radius)
    glEnd()
  of GEOMETRY_SPHERE:
    var
      R = 2 * PI / self.rings.float
      S = PI / self.sides.float
    glBegin(GL_TRIANGLE_STRIP)
    for ring in 0..self.rings:
      for sector in 0..self.sides:
        var
          s = sector.float
          r = ring.float
          pz = cos(PI - (S*s))*self.radius
          py = sin(PI - (S*s))*sin(R*r)*self.radius
          px = sin(PI - (S*s))*cos(R*r)*self.radius
        glVertex3f(px, py, pz)
        pz = cos(PI - (S*s))*self.radius
        py = sin(PI - (S*s))*sin(R*(r + 1))*self.radius
        px = sin(PI - (S*s))*cos(R*(r + 1))*self.radius
        glVertex3f(px, py, pz)
    glEnd()


  glDisable(GL_DEPTH_TEST)
  glPopMatrix()
