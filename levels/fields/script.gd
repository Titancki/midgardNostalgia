extends Node3D

@onready var bgm_player = get_node("BgmPlayer")

func _on_bgm_player_finished():
	bgm_player.play()
