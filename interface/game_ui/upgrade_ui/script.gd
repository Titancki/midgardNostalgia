extends Control

@onready var player = get_tree().root.get_node("TestWorld/Player")
@onready var choice1 = get_node("Control/VBoxContainer/Choice1Btn")
@onready var choice2 = get_node("Control/VBoxContainer/Choice2Btn")
@onready var choice3 = get_node("Control/VBoxContainer/Choice3Btn")
var chosen_upgrades = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	chosen_upgrades = Upgrades.get_3_upgrades(player)

func _process(_delta):
	if player != null:
		if chosen_upgrades.size() == 3:
			choice1.text = chosen_upgrades[0]["description"]
			choice2.text = chosen_upgrades[1]["description"]
			choice3.text = chosen_upgrades[2]["description"]
	

func _on_choice_1_btn_pressed():
	Upgrades.apply_effect(chosen_upgrades[0],player)
	Game.set_pause(false)
	queue_free()

func _on_choice_2_btn_pressed():
	Upgrades.apply_effect(chosen_upgrades[1], player)
	Game.set_pause(false)
	queue_free()

func _on_choice_3_btn_pressed():
	Upgrades.apply_effect(chosen_upgrades[2], player)
	Game.set_pause(false)
	queue_free()
