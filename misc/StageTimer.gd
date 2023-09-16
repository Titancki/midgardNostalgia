extends Timer

var masteringScene = preload("res://entities/monsters/mastering/scene.tscn")
var mastering_has_spawn = false
@onready var player = get_tree().root.get_node("TestWorld/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_time_passed() >= 600.00 and get_time_passed() <= 600.00 + delta and \
	mastering_has_spawn == false:
		var masteringInstance = masteringScene.instantiate()
		masteringInstance.transform.origin = player.transform.origin
		masteringInstance.transform.origin.x += 15
		get_parent().get_node("Entities").add_child(masteringInstance)
		mastering_has_spawn = true

func get_time_passed():
	return wait_time - time_left
