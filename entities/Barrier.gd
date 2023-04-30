extends Node2D


onready var anim := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func toggle(val := true):
	if val:
		anim.play("open")
	else:
		anim.play_backwards("open")
