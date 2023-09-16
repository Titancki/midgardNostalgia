extends Node3D

var player_pos = Vector3(0, 0, 0)  # Center position of the circle
@onready var player = get_tree().root.get_node("TestWorld/Player")
var poringScene = preload("res://entities/monsters/poring/scene.tscn")
var chonchonScene = preload("res://entities/monsters/chonchon/scene.tscn")
var wolfScene = preload("res://entities/monsters/wolf/scene.tscn")
var wave = 1
@export var difficulty_multiplier : float
var enemies_generated = []
var is_spawning = false

func _ready():
	get_node("WaveDelay").start()
	spawn_wave(wave * difficulty_multiplier)

func _process(_delta):
	if player != null:
		player_pos = player.transform.origin
	if get_tree().get_nodes_in_group("enemies").size() == 0 and not is_spawning:
		spawn_wave(difficulty_multiplier * wave)

func spawn_wave(wave_difficulty_score):
	var enemies = ["Poring", "Chonchon", "Wolf"]
	var enemyDifficulty = {
		"Poring" : 1.0,
		"Chonchon" : 4.0,
		"Wolf" : 20.0,
	}
	var toSpawn = {
		"Poring" : 0,
		"Chonchon" : 0,
		"Wolf" : 0,
	}
	print(" ")
	print("## New wave. Difficulty ", wave_difficulty_score)
	var up_threshold = wave_difficulty_score / 3.00
	while wave_difficulty_score > 0:
		var spawnables = []
		for enemy in enemies:
			if enemyDifficulty[enemy] <= wave_difficulty_score and \
			enemyDifficulty[enemy] <= up_threshold :
				spawnables.append(enemyDifficulty[enemy])
		
		var randomEnemy = randi() % spawnables.size()
		toSpawn[enemies[randomEnemy]] += 1
		wave_difficulty_score -= enemyDifficulty[enemies[randomEnemy]]
		
	print(toSpawn)
	spawn_in_clusters(poringScene, toSpawn["Poring"])
	spawn_in_clusters(chonchonScene, toSpawn["Chonchon"])
	spawn_in_clusters(wolfScene, toSpawn["Wolf"])

func spawn_in_clusters(monsterScene, amount, radius = 6.0):
	is_spawning = true
	var cluster_size = 4
	var last_cluster_size = amount % cluster_size
	var number_cluster = int(amount / cluster_size) + 1
	
	for current_cluster in range(number_cluster):
		# Find center cluster position 
		var rng = RandomNumberGenerator.new()
		var rng_point = round(rng.randf_range(0.0, 16.0))
		var angle = rng_point * (2 * PI / 16)
		var x = player_pos.x + radius * cos(angle)
		var z = player_pos.z + radius * sin(angle)
		var pointPosition = Vector3(x, 0.1, z)
		if current_cluster >= 1:
			spawn_in_circle(monsterScene, 4, 1, pointPosition)
		else:
			spawn_in_circle(monsterScene, last_cluster_size, 1, pointPosition)
		is_spawning = false
	
func spawn_in_circle(monsterScene, numPoints = 0, radius = 10.0, _center_pos = player_pos):
	for i in range(numPoints):
		var angle = i * (2 * PI / numPoints)
		var x = _center_pos.x + radius * cos(angle)
		var z = _center_pos.z + radius * sin(angle)
		var pointPosition = Vector3(x, 0.1, z)		
		var monsterInstance = monsterScene.instantiate()
		monsterInstance.transform.origin = pointPosition
		var motion = Vector3(0,0,0)
		add_child(monsterInstance)
		player.add_collision_exception_with(monsterInstance)
		if monsterInstance.test_move(monsterInstance.transform,motion):
			monsterInstance.queue_free()

func _on_wave_delay_timeout():
	wave += 1
	spawn_wave(wave * difficulty_multiplier)
	get_node("WaveDelay").start()
