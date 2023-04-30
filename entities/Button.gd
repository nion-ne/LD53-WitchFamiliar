extends Node2D

onready var press_area :Area2D = $PressArea
onready var anim = $AnimationPlayer
onready var cog_sprite := $CogSprite
onready var sparks := $MissingCogParticles
onready var fix_area := $FixArea

export(Array, NodePath) var target_paths
export var broken := false

var pressed := false
var targets := []

func _ready():
	press_area.connect("body_entered", self, "body_entered")
	press_area.connect("body_exited", self, "body_exited")
	
	for t in target_paths:
		if not t.is_empty():
			targets.append(get_node(t))
	
	if broken:
		fix_area.add_to_group("fixable")
		cog_sprite.hide()
		sparks.emitting = true
	else:
		sparks.emitting = false

func body_entered(body):
#	print(body.name, " entered!")
	if body.is_in_group("weight"):
		
		# make sure there aren't any other weights
		for o in press_area.get_overlapping_bodies():
			if o.is_in_group("weight") and not body == o:
				return
		
		anim.play("press")
		
		if broken:
			return
		
		pressed = true
		
		for t in targets:
			if t.has_method("toggle"):
				t.toggle(true)
	
func body_exited(body):
#	print(body.name, " exited!")
	if body.is_in_group("weight"):
		
		# make sure there aren't any other weights
		for o in press_area.get_overlapping_bodies():
			if o.is_in_group("weight") and not body == o:
				return
		
		anim.play_backwards("press")
		
		if broken:
			return
		
		pressed = false
		
		for t in targets:
			if t.has_method("toggle"):
				t.toggle(false)

func fix():
	cog_sprite.show()
	sparks.emitting = false
	broken = false
	
	for o in press_area.get_overlapping_bodies():
		if o.is_in_group("weight"):
			pressed = true
			for t in targets:
				if t.has_method("toggle"):
					t.toggle(true)
