extends Monster

class_name Chonchon

@export var hp : float
@export var damage :float
@export var crit_chance : float
@export var overide_speed : float
@export var experience :float

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
