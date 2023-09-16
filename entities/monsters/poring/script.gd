extends Monster

class_name Poring

@export var hp : float
@export var damage : float
@export var crit_chance : float
@export var overide_speed : float
@export var experience : float

func _ready():
	speed = overide_speed
	attributes = {
		"max_hp" : hp,
		"current_hp" : hp,
		"damage" : damage,
		"crit_chance": crit_chance,
		"block": 0,
	}
	exp_given = experience
	diffuclty_score = 1
