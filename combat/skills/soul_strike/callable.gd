extends Node3D

class_name Soul_strike

enum STATE {IDLING, SELECTING, CASTING, AFTERCAST}

var bind
var base_delay = 3.5
var delay

var delay_timer
var current_state = STATE.IDLING
var player
var is_in_process = false
var last_damage_occurance

func update():
	delay = base_delay * player.attributes["cdr"]
	cast()

func cast():
	if current_state == STATE.IDLING:
		current_state = STATE.CASTING
	
	elif current_state == STATE.CASTING and not is_in_process:
		is_in_process = true
		var casts = player.skills["soul_strike"]["current_lvl"] * 2
		for lvl in casts:
			var skills_node = player.get_parent().get_node("Entities/Skills")
			var bolt = Skills.soul_strike_scene.instantiate()
			bolt.player = player
			skills_node.add_child(bolt)
			await player.get_tree().create_timer(0.2, false).timeout
		
		delay_timer = player.get_tree().create_timer(delay, false)
		is_in_process = false
		current_state = STATE.AFTERCAST
		
	elif current_state == STATE.AFTERCAST and not is_in_process:
		is_in_process = true
		await delay_timer.timeout
		is_in_process = false
		current_state = STATE.IDLING

func has_enough_sp():
	return true

func get_delay_left():
	if delay_timer != null:
		return delay_timer.time_left
	return 0

func get_delay_left_percent():
		if delay_timer != null:
			return int((delay_timer.time_left / delay) * 100)
		return 0
	
