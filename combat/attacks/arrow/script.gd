extends Node3D

var speed = 15.0
var direction = Vector3.ZERO
@onready var player = get_tree().root.get_node("TestWorld/Player")
@onready var arrow = get_node("Arrow")
var pierce = 1
var start_pos = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	transform = start_pos.transform
	transform.origin.y = 0.5
	get_node("AudioStreamPlayer3D").play()
	
	if player.skills.has("owls_eye"):
		get_node("LifeSpan").set_wait_time(0.25 + 0.0125 * player.skills["owls_eye"]["current_lvl"])
	get_node("LifeSpan").start()
	
	if player.skills.has("pierce_arrow"):
		var rng = RandomNumberGenerator.new()
		var is_piercing = rng.randf_range(0.0, 1.0) <= player.skills["pierce_arrow"]["current_lvl"] * 0.2
		if is_piercing :
			pierce += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	arrow.transform.origin.x += speed * delta
	

func _on_life_span_timeout():
	queue_free()


func _on_arrow_body_entered(body):
	if body.is_in_group("enemies"):
		Combat.deal_damage_to(body, player, player.attributes["phy_d_damage"])
		pierce -= 1
		if pierce <= 0:
			queue_free()
