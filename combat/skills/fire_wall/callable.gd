extends Node

class_name Fire_wall

enum STATE {IDLING, SELECTING, CASTING, AFTERCAST}

var bind
var base_delay = 10
var delay

var delay_timer
var current_state = STATE.IDLING
var player

func update():
	delay = base_delay * player.attributes["cdr"]
	bind = Skills.skills["fire_wall"]["bind"]
	cast()

func cast():
	if Input.is_action_just_pressed(bind) and current_state == STATE.IDLING and has_enough_sp():
		current_state = STATE.SELECTING
	elif Input.is_action_just_pressed("attack") and current_state == STATE.SELECTING:
		current_state = STATE.CASTING
	
	var selector = player.get_node("SelectorMesh")
	if current_state == STATE.IDLING:
		selector.hide()
		
	elif current_state == STATE.SELECTING:
		selector.show()
		var pos = player.get_mouse_pos_3D()
		selector.global_transform.origin = pos
		
	elif current_state == STATE.CASTING:
		var skills_node = player.get_parent().get_node("Entities/Skills")
		var fire_wall = Skills.fire_wall_scene.instantiate()
		fire_wall.player = player
		fire_wall.global_transform = selector.global_transform
		fire_wall.look_at_from_position(fire_wall.transform.origin, player.transform.origin, Vector3.UP)
		skills_node.add_child(fire_wall)
		delay_timer = fire_wall.get_tree().create_timer(delay, false)
		current_state = STATE.AFTERCAST
		
	elif current_state == STATE.AFTERCAST:
		selector.hide()
		await delay_timer.timeout
		current_state = STATE.IDLING

func has_enough_sp():
	return player.attributes["current_sp"] >= Skills.skills["fire_wall"]["sp_cost"]

func get_delay_left():
	if delay_timer != null:
		return delay_timer.time_left
	return 0

func get_delay_left_percent():
	if delay_timer != null:
		return int((delay_timer.time_left / delay) * 100)
	return 0
