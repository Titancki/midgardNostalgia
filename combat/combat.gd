extends Node

var damageScene = preload("res://interface/damage_ui/scene.tscn")
var deathScene = preload("res://interface/game_ui/death_ui/scene.tscn")


func deal_damage_to(target, from, damage):
	if target.is_player:
		var occurance = Time.get_unix_time_from_system()
		if occurance - target.last_damage_occurance <= 0.2:
			return
		target.last_damage_occurance = Time.get_unix_time_from_system()
	var rng_block = RandomNumberGenerator.new()
	var is_block = rng_block.randf_range(0.0, 1.0) <= target.attributes["block"]
	if is_block:
		show_damage_ui("Block!", target, false, false, true)
		return
	
	var rng_crit = RandomNumberGenerator.new()
	var is_critical = rng_crit.randf_range(0.0, 1.0) <= from.attributes["crit_chance"]
	if is_critical:
		damage = damage * 2
	target.attributes["current_hp"] -= damage
	show_damage_ui(round(damage), target, is_critical)
	
	if target.attributes["current_hp"] <= 0:
		
		if target.is_player:
			var deathInstance = deathScene.instantiate()
			deathInstance.player_pos = target.transform.origin
			get_tree().root.get_node("TestWorld/GameInterface").add_child(deathInstance)
		
		target.queue_free()

func heal(target, amount):
	if target.attributes["current_hp"] + amount >= target.attributes["max_hp"]:
		target.attributes["current_hp"] = target.attributes["max_hp"]
	else:
		target.attributes["current_hp"] += amount
	show_damage_ui(amount, target, false, true, false )

func show_damage_ui(_damage_value, target, _is_critical=false, _is_heal=false, _is_block=false):
	var damageInstance = damageScene.instantiate()
	damageInstance.text = str(_damage_value)
	damageInstance.is_crit = _is_critical
	damageInstance.is_heal = _is_heal
	damageInstance.is_block = _is_block
	damageInstance.transform = target.transform
	var target_shape = target.get_node_or_null("CollisionShape3D")
	if target_shape:
		var shape = target_shape.get_shape()
		if shape is SphereShape3D:
			var sphere_radius = shape.get_radius()
			damageInstance.transform.origin.y += sphere_radius * 2.0
		elif shape is CapsuleShape3D:
			damageInstance.transform.origin.y += target_shape.get_shape().get_height()
		elif shape is BoxShape3D:
			damageInstance.transform.origin.y += target_shape.get_shape().get_size().y
	get_tree().root.get_node("TestWorld").add_child(damageInstance)
