extends Node2D

onready var music := $Music

onready var whoosh := $Whoosh

var allow_music := true

func play_music():
	if not allow_music:
		return
	music.play()
	
func _process(delta):
	if Input.is_action_just_pressed("mute"):
		music.playing = !allow_music
		allow_music = !allow_music
