extends Node

const RESTART_TIME := 5.0

var restarting := false
var timer
var last_level_name = "intro"

onready var level_title_UI = get_tree().get_nodes_in_group("level_title")[0]

var levels := {
	"intro": "res://levels/Intro.tscn",
	"level1": "res://levels/Level1.tscn",
	"level2": "res://levels/Level2.tscn",
	"level3": "res://levels/Level3.tscn",
	"level4": "res://levels/Level4.tscn",
	"level5": "res://levels/Level5.tscn",
	"level6": "res://levels/Level6.tscn",
	"ending": "res://levels/Ending.tscn",
}

var level_titles := {
	"level1": "1/6 - Beginning",
	"level2": "2/6 - Swap",
	"level3": "3/6 - Juggle",
	"level4": "4/6 - Repair",
	"level5": "5/6 - Descent",
	"level6": "6/6 - As above. So below",
}


func _process(delta):
	if Input.is_action_just_pressed("restart"):
		if not restarting:
			restart_countdown()
	if Input.is_action_just_released("restart"):
		restarting = false
		get_tree().get_nodes_in_group("restart_label")[0].hide()
#		if timer != null:
#			timer.stop()
			


func change_level(level_name : String):
	FX.fade_out()
	yield(FX, "fx_complete")

	get_tree().change_scene(levels[level_name])
	last_level_name = level_name
	yield(get_tree(), "idle_frame")
	
	get_player().set_input(false)
	
	FX.fade_in()
	yield(FX, "fx_complete")
	
	if level_name in level_titles.keys():
		level_title_UI.text = level_titles[level_name]
		level_title_UI.get_node("AnimationPlayer").play("fade")
	
	get_player().set_input(true)
	
	if level_name != "intro" and level_name != "ending": 
		if not Sounds.music.playing:
			Sounds.play_music()

func get_player():
	return get_tree().get_nodes_in_group("player")[0]

func restart_countdown():
	restarting = true
	get_tree().get_nodes_in_group("restart_label")[0].show()
	timer = get_tree().create_timer(RESTART_TIME)
	yield(timer, "timeout")
	if Input.is_action_pressed("restart") and restarting:
		change_level(last_level_name)
		
	
