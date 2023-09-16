extends Entity

class_name Player

enum DIRECTION {RIGHT, UPRIGHT, UP, UPLEFT, LEFT, DOWNLEFT, DOWN, DOWNRIGHT}
enum JOB {NOVICE, SWORDMAN, ARCHER, MAGE, THIEF, ACOLYTE, MERCHANT}

signal on_lvl_up
signal on_job_change

var current_direction = DIRECTION.DOWN
var animation_directions = ["walk_right", "walk_upright", "walk_up", "walk_upleft", 
"walk_left", "walk_downleft", "walk_down", "walk_downright"]
var is_walking = false


@onready var autoAttack = get_node("AutoAttack")
@onready var head = get_node("Heads")
@onready var camera = get_node("Camera3D")
@onready var projectiles = get_tree().root.get_node("TestWorld/Entities/Projectiles")
@onready var recovery_delay = get_node("RecoveryDelay")
# Player Stats
var current_exp = 0.00
var lvl = 9
var exp_to_next = 19.0
var current_job = JOB.NOVICE
var last_damage_occurance = Time.get_unix_time_from_system()

func _ready():
	is_player = true
	speed = 4.0
	stats = {
		"str": 1, #10% dommage physical mélée
		"vit": 1, # 2% hp, 1% chance block
		"dex": 1, #10% dommage physical distance, CDR
		"agi": 1, # -1% AttackDelay, 5% movespeed
		"int": 1, #10 magique dommage
		"luk": 1, # 1% crit
	}
	
	for key in Jobs.attributes[current_job]:
		attributes[key] = Jobs.attributes[current_job][key]
	attributes["current_hp"] = attributes["max_hp"]
	handle_animation()
	recovery_delay.start()
	
	
func _physics_process(_delta):
	Jobs.update_attributes(self)
	_lvl_up()
	_move()
	_attack()
	handle_animation()
	Status.endure(self)
	Skills.cast_skills()

func _move():
	if not is_bumped:
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		move_and_slide()
	
	if Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		current_direction = DIRECTION.DOWNLEFT
		is_walking = true
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
		current_direction = DIRECTION.DOWNRIGHT
		is_walking = true
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		current_direction = DIRECTION.UPLEFT
		is_walking = true
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		current_direction = DIRECTION.UPRIGHT
		is_walking = true
	elif Input.is_action_pressed("move_down"):
		current_direction = DIRECTION.DOWN
		is_walking = true
	elif Input.is_action_pressed("move_left"):
		current_direction = DIRECTION.LEFT
		is_walking = true
	elif Input.is_action_pressed("move_up"):
		current_direction = DIRECTION.UP
		is_walking = true
	elif Input.is_action_pressed("move_right"):
		current_direction = DIRECTION.RIGHT
		is_walking = true
	else:
		is_walking = false

func _attack():
	autoAttack.look_at(get_mouse_pos_3D(), Vector3.UP)
	autoAttack.transform.basis = Basis(Vector3(0, 1, 0), deg_to_rad(90)) * autoAttack.transform.basis
	
	if Input.is_action_pressed("attack") and can_attack:
		if current_job == JOB.ARCHER:
			var arrow_attack_instance = Attacks.arrow_attack_scene.instantiate()
			arrow_attack_instance.start_pos = autoAttack.duplicate()
			arrow_attack_instance.start_pos.transform = autoAttack.global_transform
			projectiles.add_child(arrow_attack_instance)
		
		elif current_job == JOB.SWORDMAN:
			var sword_attack_instance = Attacks.sword_attack_scene.instantiate()
			autoAttack.add_child(sword_attack_instance)
			sword_attack_instance.scale = Vector3(1.3, 1.3, 1.3)
			sword_attack_instance.damage = attributes["phy_m_damage"]
			sword_attack_instance.source = self
		
		elif current_job == JOB.MAGE:
			pass
		
		else:
			var sword_attack_instance = Attacks.sword_attack_scene.instantiate()
			autoAttack.add_child(sword_attack_instance)
			sword_attack_instance.damage = attributes["phy_m_damage"]
			sword_attack_instance.source = self
			
		autoAttack.get_node("AttackDelay").start()
		can_attack = false
	
func handle_animation():
	var animated_body = Jobs.get_animated_body(self)
	animated_body.play()
	var sprite_size = abs(animated_body.get_sprite_frames().get_frame_texture(animation_directions[current_direction],animated_body.get_frame()).get_size())
	animated_body.offset.x = sprite_size.x * 0.5 * -1
	if is_walking:
		animated_body.play(animation_directions[current_direction])
	else:
		animated_body.set_frame_and_progress(0, 0.0)
	
	
	var body_size = abs(animated_body.get_sprite_frames().get_frame_texture(
		animation_directions[current_direction],
		animated_body.get_frame()).get_size())
	var head_size = abs(head.get_sprite_frames().get_frame_texture(
		animation_directions[current_direction],
		head.get_frame()).get_size())
	head.offset.x = head_size.x * 0.5 * -1
	head.offset.y = body_size.y + 13
	head.play(animation_directions[current_direction])

func _lvl_up():
	if current_exp >= exp_to_next:
		
		lvl += 1
		current_exp = current_exp - exp_to_next
		exp_to_next = 19.0 * pow(1.05, lvl)
		attributes["current_hp"] = attributes["max_hp"]
		
		if lvl == 10:
			emit_signal("on_job_change")
			Game.set_pause(true)
			return
		
		emit_signal("on_lvl_up")
		Game.set_pause(true)
			
		return
	return

func get_mouse_pos_3D():
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(mousePos)
	params.to = params.from + camera.project_ray_normal(mousePos) * 2000
	params.collision_mask = 2
	params.exclude = [] # Empty array for no exclusions
	var results = spaceState.intersect_ray(params)

	if results.size() > 0:
		return results["position"]

	return Vector3.ZERO

func _on_recovery_delay_timeout():
	if attributes["recovery"]>0:
		Combat.heal(self,attributes["recovery"])
	
	if attributes["max_sp"] - attributes["current_sp"] >= attributes["sp_regen"]:
		attributes["current_sp"] += attributes["sp_regen"]
	else:
		attributes["current_sp"] = attributes["max_sp"]
	recovery_delay.start()
