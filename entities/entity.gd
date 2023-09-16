extends CharacterBody3D

class_name Entity

var attributes = {
	"attack_delay" : 0,
	"max_hp" : 0,
	"max_sp" : 0,
	"sp_regen": 1,
	"phy_m_damage" : 0,
	"phy_d_damage" : 0,
	"cdr" : 0.0,
	"magic_damage" : 0,
	"crit_chance" : 0,
	"current_hp":0,
	"current_sp" : 10.0,
	"block": 0,
	"recovery": 0,
}
var stats = {
	"str": 0, #10% dommage physical mélée
	"vit": 0, # 2% hp, 1% chance block
	"dex": 0, #10% dommage physical distance, CDR
	"agi": 0, # -1% AttackDelay, 5% movespeed
	"int": 0, #10 magique dommage
	"luk": 0, # 1% crit
}
var speed = 3.0
var is_bumped = false
var is_knockbacked = false
var can_attack = true
var skills = {}
var statuses = []
var is_player = false
	
func knockbacked(force, duration = 0.15):
	if not is_knockbacked:
		is_knockbacked = true
		var _speed = speed
		speed = _speed * (force * -1.0)
		await get_tree().create_timer(duration).timeout
		speed = _speed
		is_knockbacked = false

func bump():
	is_bumped = true
	if not statuses.has("endure"):
		await get_tree().create_timer(0.075).timeout
	is_bumped = false

func when_damage_taken(_damage_value: int, _is_critical):
	pass

func _on_attack_delay_timeout():
	can_attack = true
