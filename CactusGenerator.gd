extends KinematicBody

var ground
var ground_size_min
var ground_size_max

var velocity = Vector3()
var cactus
var cactus_position = Vector3()

const SPEED = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  # helper function to spawn the cactus
  spawn()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _physics_process(_delta):
  velocity = move_and_slide(velocity, Vector3(0,1,0))
  # Send cactus back once it reaches the sides
  var cactus_pos = cactus.get_translation()
  if cactus_pos.x < ground_size_min.x || cactus_pos.x > ground_size_max.x:
    spawn()
  if cactus_pos.z < ground_size_min.z || cactus_pos.z > ground_size_max.z:
    spawn()
  #print(cactus.get_translation())
  pass

func spawn():
  ground = get_node("../Ground")
  cactus = $"."

  # Greab the dimentions of X and Z since it's just the ground (no y value)
  var dimentions = ground.get_global_transform().basis[0] + ground.get_global_transform().basis[2]
  ground_size_min = ground.get_aabb().position * dimentions
  ground_size_max = ground.get_aabb().end * dimentions

  # Set a random position for the cactus to start at
  randomize() # use randomize() to make things different each run
  cactus_position.z = rand_range(ground_size_min.z,ground_size_max.z)
  cactus_position.x = ground_size_max.x - rand_range(0,5)
  cactus_position.y = 2
  cactus.set_translation(cactus_position)
  velocity.x = -SPEED

  # Set a rondom rotation for the cactus
  randomize()
  var cactus_rot = rand_range(360,0)
  cactus.set_rotation_degrees(Vector3(0,cactus_rot,0))
