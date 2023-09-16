extends Control

@onready var player = get_tree().root.get_node("TestWorld/Player")
enum JOB {NOVICE, SWORDMAN, ARCHER, MAGE, THIEF, ACOLYTE, MERCHANT}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_swordman_btn_pressed():
	player.current_job = player.JOB.SWORDMAN
	print("change to swordman")
	Game.set_pause(false)
	queue_free()

func _on_mage_btn_pressed():
	player.current_job = player.JOB.MAGE
	Skills.add_or_lvl_up("soul_strike", player)
	print("change to mage")
	Game.set_pause(false)
	queue_free()

func _on_archer_btn_pressed():
	player.current_job = player.JOB.ARCHER
	print("change to archer")
	Game.set_pause(false)
	queue_free()

func _on_thief_btn_pressed():
	player.current_job = player.JOB.THIEF
	print("change to thief id:", player.current_job)
	Game.set_pause(false)
	queue_free()

func _on_acolyte_btn_pressed():
	player.current_job = player.JOB.ACOLYTE
	print("change to acolyte id:", player.current_job)
	Game.set_pause(false)
	queue_free()

func _on_merchant_btn_pressed():
	player.current_job = player.JOB.MERCHANT
	print("change to merchant id:", player.current_job)
	Game.set_pause(false)
	queue_free()
