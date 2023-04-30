extends RigidBody2D

onready var collision_shape = $CollisionShape2D

export var weighted := true
export var pickup_offset := Vector2.ZERO
export var is_cog := false
export var is_package := false

func _ready():
	add_to_group("pickup")
	if weighted:
		add_to_group("weight")
	if is_cog:
		add_to_group("cog")
	if is_package:
		add_to_group("package")

func picked_up():
	mode = MODE_STATIC
	collision_shape.disabled = true
	
func dropped():
	mode = MODE_RIGID
	collision_shape.disabled = false

func get_offset():
	return pickup_offset
