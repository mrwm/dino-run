extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera
var character
var is_moving

const SPEED = 6
const JUMP = 10
const ACCELERATION = 3
const DE_ACCELERATION = 5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
  #print("Dino ready")
  character = get_node(".")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  camera = get_node("target/Camera").get_global_transform()

  var dir = Vector3()

  if (Input.is_action_pressed("ui_up")):
    #print("LEFT")
    dir += -camera.basis[2]
  if (Input.is_action_pressed("ui_down")):
    #print("RIGHT")
    dir += camera.basis[2]
  if (Input.is_action_pressed("ui_left")):
    #print("UP")
    dir += -camera.basis[0]
  if (Input.is_action_pressed("ui_right")):
    #print("DOWN")
    dir += camera.basis[0]

  if (Input.is_action_pressed("ui_select")):
    if is_on_floor():
      #print("JUMP")
      velocity.y = JUMP

  dir.y = 0
  dir = dir.normalized()

  velocity.y += delta * gravity

  var hv = velocity
  hv.y = 0

  var new_pos = dir * SPEED
  var accel = DE_ACCELERATION

  if (dir.dot(hv) > 0):
    accel = ACCELERATION

  # Detect if the character is moving
  hv = hv.linear_interpolate(new_pos, accel * delta)
  if (abs(hv.x) > 0.01) && (abs(hv.z) > 0.01):
    is_moving = true
  else:
    is_moving = false

  velocity.x = hv.x
  velocity.z = hv.z
  velocity = move_and_slide(velocity, Vector3(0,1,0))

  if is_moving:
    #print(velocity)
    var angle = atan2(hv.x, hv.z)
    var char_rot = character.get_rotation()
    char_rot.y = angle
    character.set_rotation(char_rot)
