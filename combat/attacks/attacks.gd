extends Node

enum JOB {NOVICE, SWORDMAN, ARCHER, MAGE, THIEF, ACOLYTE, MERCHANT}
var attacks = {
	
}

@onready var arrow_attack_scene = preload("res://combat/attacks/arrow/scene.tscn")
@onready var sword_attack_scene = preload("res://combat/attacks/sword/scene.tscn")
