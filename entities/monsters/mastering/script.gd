extends Monster

class_name Mastering

@export var hp : float
@export var damage : float
@export var crit_chance : float
@export var experience : float
@export var overide_speed : float

var centerPosition
var poringScene = preload("res://entities/monsters/poring/scene.tscn")

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
	diffuclty_score = 1
	get_node("SpawnTimer").start()
	centerPosition = transform.origin

func _process(_delta):
	centerPosition = transform.origin

func spawn_enemies(monsterScene, numPoints = 4, radius = 5.0):
	for i in range(numPoints):
		var angle = i * (2 * PI / numPoints)
		var x = centerPosition.x + radius * cos(angle)
		var z = centerPosition.z + radius * sin(angle)
		var pointPosition = Vector3(x, 0.1, z)

		var monsterInstance = monsterScene.instantiate()
		monsterInstance.transform.origin = pointPosition
		monsterInstance.experience = 0
		var motion = Vector3(0,0,0)
		get_parent().add_child(monsterInstance)
		if monsterInstance.test_move(monsterInstance.transform,motion):
			monsterInstance.queue_free()

func _on_spawn_timer_timeout():
	spawn_enemies(poringScene)
	get_node("SpawnTimer").start()
