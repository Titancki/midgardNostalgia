extends Monster

class_name Wolf

@export var hp = 100
@export var damage = 3
@export var crit_chance = 0
@export var overide_speed : float
@export var experience = 100

func _ready():
	attributes = {
		"max_hp" : hp,
		"current_hp" : hp,
		"damage" : damage,
		"crit_chance": crit_chance,
		"block": 0,
	}
	speed = overide_speed
	exp_given = experience
	diffuclty_score = 4
