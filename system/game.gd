extends Node

@export var can_toggle_pause: bool = true

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("menu_pause"):
		if !get_tree().paused:
			pause()
		else:
			resume()

func pause():
	if can_toggle_pause:
		get_tree().set_deferred("paused", true)

func resume():
	if can_toggle_pause:
		get_tree().set_deferred("paused", false)

func set_pause(isPaused):
	if isPaused:
		pause()
	else:
		resume()

func is_paused():
	if get_tree().paused == true:
		return true
	return false
