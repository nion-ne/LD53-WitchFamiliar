extends Node2D

onready var area := $Area2D
onready var package_label := $PackageLabel

export var next_level := ""

func _ready():
	area.connect("body_entered", self, "body_entered")
	area.connect("body_exited", self, "body_exited")
	
	package_label.hide()

func body_entered(body):
	if body.is_in_group("player"):
		if body.holding:
			if body.get_holding().is_in_group("package"):
				
				finish_level()
				
			else:
				package_label.show()
		else:
			
			for b in area.get_overlapping_bodies():
				if b != body:
					if b.is_in_group("package"):
						finish_level()
			
			package_label.show()

func finish_level():
	WorldLoader.get_player().set_input(false)
	WorldLoader.change_level(next_level)



func body_exited(body):
	if body.is_in_group("player"):
		package_label.hide()
