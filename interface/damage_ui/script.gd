extends Label3D

@onready var showTimer = get_node("ShowTimer")
@onready var crit_sprite = get_node("critSprite")
var is_crit = false
var is_block = false
var is_heal = false

func _ready():
	showTimer.start()
	
	if is_block:
		get_node("BlockPlayer3D").play()
	
	if is_heal:
		get_node("HealPlayer3D").play()
		self.modulate = Color.html("#00f600")
		self.outline_modulate = Color.html("#0ebb00")
	
	if is_crit:
		crit_sprite.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	transform.origin.y += 0.01
	
func _on_show_timer_timeout():
	queue_free()
