extends Area3D

var enemies_inreach = []
var damage
var source

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if source:
		get_node("AnimatedSprite3D").play("attack")
		get_node("AudioStreamPlayer3D").play()

func _on_animated_sprite_3d_animation_finished():
	queue_free()

func _on_attack_enemies_entered(body):
	if body.is_in_group("enemies"):
		if body not in enemies_inreach:
			enemies_inreach.append(body)
			for enemy in enemies_inreach:
				Combat.deal_damage_to(enemy, source, damage)

func _on_attack_enemies_exited(body):
	if body.is_in_group("enemies"):
		if body in enemies_inreach:
			enemies_inreach.erase(body)
