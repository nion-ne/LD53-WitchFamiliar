extends Node2D

onready var label := $Label
onready var anim := $AnimationPlayer

var type_speed := 0.4

var allow_input := false

var text_pause := false

func _ready():
	label.percent_visible = 0



func _physics_process(delta):
	
	if not text_pause:
		typing()
	
	
	if Input.is_action_just_pressed("select"):
		if allow_input:
			WorldLoader.change_level("level1")
	

func typing():
	label.percent_visible += (1.0 / label.text.length()) * type_speed

	if label.percent_visible >= 1.0:
		anim.play("fade")
		allow_input = true
	
