# author: Ethosa
## Provides working with GLSL.
import
  ../thirdparty/gl,
  ../private/templates,
  exceptions


type
  GLSLShaderObj* = object
    id*: Gluint

proc GLSLShader*(vertex_source, fragment_source: string): GLSLShaderObj =
  result = GLSLShaderObj(id: glCreateProgram())
  var
    vertex = glCreateShader(GL_VERTEX_SHADER)
    fragment = glCreateShader(GL_FRAGMENT_SHADER)
    success: Glint
    infoLog: cstring

  loadGLSLShader(vertex, vertex_source)
  loadGLSLShader(fragment, fragment_source)

  glAttachShader(result.id, vertex)
  glAttachShader(result.id, fragment)
  glLinkProgram(result.id)
  glGetProgramiv(result.id, GL_COMPILE_STATUS, addr success)
  if success == 0:
    glGetProgramInfoLog(result.id, 512, nil, infoLog)
    throwError(ShaderCompileError, $infoLog)

  glDeleteShader(vertex)
  glDeleteShader(fragment)

proc GLSLShaderFile*(vertex_shader, fragment_shader: string): GLSLShaderObj =
  var
    vertex = open(vertex_shader)
    fragment = open(fragment_shader)
  result = GLSLShader(vertex.readAll(), fragment.readAll())
  vertex.close()
  fragment.close()

proc use*(shader: GLSLShaderObj) =
  glUseProgram(shader.id)

proc freeMemory*(shader: GLSLShaderObj) =
  glDeleteProgram(shader.id)
