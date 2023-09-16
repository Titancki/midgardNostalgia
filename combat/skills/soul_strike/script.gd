extends Node3D

var speed = 10
var _range = 25.0
var target
var player

var to_destroy = false

func _ready():
	transform.origin = player.global_transform.origin
	target = get_nearest_enemy()
	if not is_in_range(target):
		queue_free()
	show()
	$AudioStreamPlayer3D.play()

func _process(delta):
	$Path3D/PathFollow3D.progress += speed * delta
	
	if target != null:
		if target.is_queued_for_deletion():
			target = null
			return
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		var new_position = global_transform.origin + direction * speed * delta
		global_transform.origin = new_position
	else:
		if $AudioStreamPlayer3D.is_playing():
			to_destroy = true
			hide()
		else:
			queue_free()
			
	if to_destroy and not $AudioStreamPlayer3D.is_playing():
		queue_free()

func get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearestEnemy: Node = null
	var nearestDistance: float = INF

	for enemy in enemies:
		var distance = global_transform.origin.distance_to(enemy.global_transform.origin)
		if distance < nearestDistance:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy

func is_in_range(_target):
	var _is_in_range = false
	if _target and _target != null:
		var distance = global_transform.origin.distance_to(_target.global_transform.origin)
		_is_in_range = distance <= _range
	return _is_in_range

func _on_area_3d_body_entered(body):
	if body in get_tree().get_nodes_in_group("enemies"):
		Combat.deal_damage_to(body, player, player.attributes["magic_damage"] * 0.25)
		queue_free()
