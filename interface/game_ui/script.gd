extends Control

@onready var player = get_tree().root.get_node("TestWorld/Player")
@onready var upgrade_ui_scene = preload("res://interface/game_ui/upgrade_ui/scene.tscn")
@onready var job_change_ui_scene = preload("res://interface/game_ui/job_ui/scene.tscn")
@onready var pause_interface_scene = preload("res://interface/game_ui/pause_ui/scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	player.on_lvl_up.connect(choose_upgrade)
	player.on_job_change.connect(choose_job)

func _process(_delta):
	if Input.is_action_just_pressed("menu_pause") and get_node_or_null("PauseInterface") == null:
		add_child(pause_interface_scene.instantiate())


func choose_upgrade():
	var upgrade_ui_instance = upgrade_ui_scene.instantiate()
	add_child(upgrade_ui_instance)

func choose_job():
	var job_change_ui_instance = job_change_ui_scene.instantiate()
	add_child(job_change_ui_instance)

