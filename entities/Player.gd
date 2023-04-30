extends KinematicBody2D

onready var pickup_area := $PickupArea
onready var pickup_label := $"%PickupLabel"
onready var pickup_location := $PickupLocation
onready var anim := $AnimatedSprite
onready var collision_anim = $CollisionAnimator

var speed := 135
var holding_speed := 100
var velocity := Vector2.ZERO
var can_pickup := false
var holding := false
var holding_cog := false
var allow_input := true

func _init():
	add_to_group("player")

func _ready():
	pickup_area.connect("body_entered", self, "body_entered")
	pickup_area.connect("body_exited", self, "body_exited")
	pickup_area.connect("area_entered", self, "area_entered")
	pickup_label.hide()
	

func move_input():
	if not allow_input: return
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction
	
	if holding:
		velocity *= holding_speed
	else:
		velocity *= speed

	
	if input_direction.x > 0:
		$AnimatedSprite.flip_h = false
	elif input_direction.x < 0:
		$AnimatedSprite.flip_h = true
		
	if is_on_floor():
		anim.play("standing")
	else:
		anim.play("flying")
	
	
func _unhandled_input(event):
	if not allow_input: return
	
	if event.is_action_pressed("select"):
		if can_pickup:
			pickup_object()
			print(get_holding().name, " picked up!")
		elif holding:
			print(get_holding().name, " dropped!")
			drop_object()

	

func _physics_process(delta):
	move_input()
	move_and_slide(velocity, Vector2.UP, false, 4, 0.786, false)

func pickup_object():
	for obj in pickup_area.get_overlapping_bodies():
		if obj.is_in_group("pickup"):
			obj.get_parent().remove_child(obj)
			
			obj.picked_up()
			holding = true
			
			collision_anim.play("carrying")
			
			can_pickup = false
			if obj.is_in_group("cog"):
				holding_cog = true
			
			pickup_location.add_child(obj)
			obj.position = obj.get_offset()
			
			pickup_label.text = "Z to drop"
			pickup_label.show()
			return
	
	

func drop_object():
	var obj = pickup_location.get_child(0)
	var obj_pos = obj.global_position
	var player_pos = global_position
	
	holding = false
	obj.dropped()
	holding_cog = false
	
	collision_anim.play("RESET")
	
	pickup_location.remove_child(obj)
	obj.global_position = obj_pos
	get_parent().add_child(obj)
	
	obj.apply_impulse(Vector2.DOWN, Vector2.DOWN)
	
	yield(get_tree(), "idle_frame")
	position = player_pos
	

	


func body_entered(body):
	if not body.is_in_group("pickup") or holding:
		return

	pickup_label.text = "Z to pickup"
	pickup_label.show()
	can_pickup = true
	
func body_exited(body):
	if not body.is_in_group("pickup") or holding:
		return
	
	# make sure we don't dismiss any other opportunities
	for b in pickup_area.get_overlapping_bodies():
		if b.is_in_group("pickup"):
			return
	
	pickup_label.hide()
	can_pickup = false

func area_entered(area):
	if area.is_in_group("fixable") and holding_cog:
		area.get_parent().fix()
		
		holding = false
		holding_cog = false
		get_holding().queue_free()
		

func get_holding():
	return pickup_location.get_child(0)

func set_input(val := false):
	velocity = Vector2.ZERO
	allow_input = val
