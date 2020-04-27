require 'mittsu'

require_relative 'generator'

generator = Generator.new('F')
actions = generator.config['actions']
@lines = []
@pos = nil
3.times { generator.generate }

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

X_AXIS = Mittsu::Vector3.new(1.0, 0.0, 0.0)
Y_AXIS = Mittsu::Vector3.new(0.0, 1.0, 0.0)
Z_AXIS = Mittsu::Vector3.new(0.0, 0.0, 1.0)

scene = Mittsu::Scene.new
camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: '01 Scene Example'

def forward(scene)
  puts 'forward'
  material = Mittsu::LineBasicMaterial.new(color: 0xff00ff)
  geometry = Mittsu::Geometry.new()
  geometry.vertices.push(Mittsu::Vector3.new(0, 0, 0.0))
  geometry.vertices.push(Mittsu::Vector3.new(0, 1, 0.0))
  line = Mittsu::Line.new(geometry, material)
  @lines << line
  scene.add(line)
  scene.translate_y(-0.005)
end

def turn_left(scene)
  puts 'turn_left'
  scene.rotate_on_axis(Z_AXIS, -0.2)
end

def turn_right(scene)
  puts 'turn_right'
  scene.rotate_on_axis(Z_AXIS, 0.2)
end

def push(scene)
  puts 'push'
  scene.glPushMatrix
end

def pop(scene)
  puts 'pop'
  scene.glPopMatrix
end

camera.position.z = 5.0
camera.position.y = 0.0
camera.look_at(Mittsu::Vector3.new)

generator.axiom_chars.each_with_index do |char, index|
  steps = actions[char.to_s]
  steps.each do |step|
    send(step, scene)
  end
end

renderer.window.on_resize do |width, height|
  renderer.set_viewport(0, 0, width, height)
  camera.aspect = width.to_f / height.to_f
  camera.update_projection_matrix
end

x = 0
renderer.window.run do
  # x += 1
  for line in @lines
    line.rotation.z = x * 0.1
  end

  renderer.render(scene, camera)
end
