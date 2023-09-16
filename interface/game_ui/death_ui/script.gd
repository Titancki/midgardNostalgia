extends Control

@onready var go_to_menu_btn = get_node("GoToMenuBtn")
@onready var death_camera = get_tree().root.get_node("TestWorld/DeathCamera")
var player_pos = Vector3()

func _ready():
	death_camera.transform.origin = player_pos
	death_camera.transform.origin.z += 7
	death_camera.transform.origin.y += 7

func _on_go_to_menu_btn_pressed():
	get_tree().change_scene_to_file("res://home.tscn")
	queue_free()
