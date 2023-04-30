extends CanvasLayer

onready var player_vignette := $PlayerVignette
onready var screen_fade := $ScreenFade

signal fx_complete

# Called when the node enters the scene tree for the first time.
func _ready():
#	player_vignette.hide()
#	yield(get_tree(), "idle_frame")
#	iris_shot()

	screen_fade.modulate = Color.transparent

#	fade_out()
	
#	fade_in()
	
	
	
	
func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(screen_fade, "modulate", Color.white, 1)
	yield(tween, "finished")
	emit_signal("fx_complete")
	
func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(screen_fade, "modulate", Color.transparent, 1)
	yield(tween, "finished")
	emit_signal("fx_complete")
	
	
#
func iris_shot():
	
	var player = WorldLoader.get_player()
	var player_position = player.get_global_transform_with_canvas().origin / get_viewport().size
	player_vignette.material.set_shader_param("player_position", player_position)
	
	
	player_vignette.show()

