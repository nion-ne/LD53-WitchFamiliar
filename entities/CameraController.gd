extends Camera2D

const LIMIT_MARGIN = 0

var limits


func _ready():
	if not get_tree().get_nodes_in_group("level_limits").empty():
		limits = get_tree().get_nodes_in_group("level_limits")[0].get_global_rect()
		
		limit_left = limits.position.x + LIMIT_MARGIN
		limit_top = limits.position.y + LIMIT_MARGIN
		limit_bottom = limits.end.y - LIMIT_MARGIN#size.size.y + size.position.y
		limit_right = limits.end.x - LIMIT_MARGIN#size.size.x + size.position.x
		
	else:
		print("limits not found")
