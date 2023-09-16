extends Node3D

var current_lvl
var player
var hit_count
var sp_cost = 15

func _ready():
	if player.skills.has("fire_wall"):
		current_lvl = player.skills["fire_wall"]["current_lvl"]
	player.attributes["current_sp"] -= Skills.skills["fire_wall"]["sp_cost"]
	hit_count = 5 * current_lvl
	$LifeTimer.start()


func _on_life_time_timeout():
	queue_free()

func _on_area_3d_body_entered(body):
	if body in get_tree().get_nodes_in_group("enemies") and body != null:
		Combat.deal_damage_to(body, player, player.attributes["magic_damage"] * 0.15)
		body.knockbacked(2)
		hit_count -= 1
		if hit_count <= 0:
			queue_free()
