extends Entity

class_name Monster

@onready var animation = get_node("AnimatedSprite3D")
@onready var player = get_tree().root.get_node("TestWorld/Player")
@onready var nav_agent = get_node("NavigationAgent3D")
@onready var attack_delay_timer = get_node("AttackDelay")
@onready var attack_player = get_node("AttackPlayer3D")
@onready var move_player = get_node("MovePlayer3D")

var is_player_inrange = false
var is_moving = true
var exp_given = null
var diffuclty_score = 1


func _physics_process(_delta):
	if player != null:
		move_towards(player.transform.origin, self, nav_agent, speed)
	_attack()	

# Move and rotate character to a position on a navMesh
func move_towards(_target:Vector3, _character: CharacterBody3D, _nav_agent: NavigationAgent3D, _speed: float):
	if _character != null and _target != null:
		if _target.z >= _character.global_transform.origin.z:
			animation.play("down")
			pass
		else:
			animation.play("up")
			pass
		is_moving = true
		nav_agent.set_target_position(_target)
		var current_location = _character.global_transform.origin
		var next_location = _nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * _speed
		_character.velocity = new_velocity
		_character.move_and_slide()		

func _attack():
	if can_attack and is_player_inrange:
		is_moving = false
		Combat.deal_damage_to(player, self, attributes["damage"])
		attack_delay_timer.start()
		can_attack = false
		attack_player.play()
		player.bump()

## SIGNALS ##
func _on_attack_area_player_entered(body):
	if body == player:
		is_player_inrange = true

func _on_attack_area_player_exited(body):
	if body == player :
		is_player_inrange = false

	can_attack = true

func _on_tree_exited():
	if player != null:
		player.current_exp += exp_given

func _on_sound_delay_timer_timeout():
	if is_moving:
		move_player.play()

func _on_move_player_3d_finished():
	move_player.get_node("SoundDelayTimer").start()
