extends Control

@onready var player = get_tree().root.get_node("TestWorld/Player")
@onready var stage_timer = get_tree().root.get_node("TestWorld/StageTimer")
@onready var hp_bar = get_node("HBoxContainer/VBoxContainer/HPBar")
@onready var hp_value = get_node("HBoxContainer/VBoxContainer/HPBar/Value")
@onready var sp_bar = get_node("HBoxContainer/VBoxContainer/SPBar")
@onready var sp_value = get_node("HBoxContainer/VBoxContainer/SPBar/Value")
@onready var exp_bar = get_parent().get_node("LevelInfo/HBoxContainer/ExpBar")
@onready var lvl = get_node("HBoxContainer/VBoxContainer/HBoxContainer/LevelText")
@onready var jobtext = get_node("HBoxContainer/VBoxContainer/HBoxContainer/JobText")
@onready var stage_timer_label = get_node("Timer")
@onready var effectScene = preload("res://misc/empty_effect.tscn")

var jobs = ["Novice", "Swordman", "Archer", "Mage", "Acolyte", "Merchant"]

func _ready():
	Status.on_status_updated.connect(update_statuses)

func _process(_delta):
	if player != null:
		hp_value.text = str(player.attributes["current_hp"], "/", player.attributes["max_hp"])
		hp_bar.set_max(player.attributes["max_hp"])
		hp_bar.set_value(player.attributes["current_hp"])
		sp_value.text = str(player.attributes["current_sp"], "/", player.attributes["max_sp"])
		sp_bar.set_max(player.attributes["max_sp"])
		sp_bar.set_value(player.attributes["current_sp"])
		exp_bar.set_max(player.exp_to_next)
		exp_bar.set_value(player.current_exp)
		lvl.text = str("Lvl. ", player.lvl)
		jobtext.text = jobs[player.current_job]
	stage_timer_label.text = formatTime(stage_timer.get_time_left())
	update_skill_bar()
	update_auto()
	
func formatTime(seconds: int) -> String:
	var minutes = round(seconds / 60.00)
	var secondsRemaining = seconds % 60
	var formattedMinutes = pad_zero(minutes,2)
	var formattedSeconds = pad_zero(secondsRemaining,2)

	return formattedMinutes + ":" + formattedSeconds

func pad_zero(value: int, digits: int) -> String:
	var strValue = str(value)
	while strValue.length() < digits:
		strValue = "0" + strValue
	return strValue

func update_statuses():
	for child in $effects.get_children():
		if child != null:
			child.queue_free()
	
	for status in player.statuses:
		var effectInstance = effectScene.instantiate()
		var stylebox = StyleBoxTexture.new()
		var img = load(Skills.skills[status]["img"]) 
		stylebox.texture = img
		effectInstance.add_theme_stylebox_override("panel", stylebox)
		$effects.add_child(effectInstance)

func update_skill_bar():
	var skill1 = Skills.get_skill_by_bind(player, "skill1")
	var skill2 = Skills.get_skill_by_bind(player, "skill2")
	var skill3 = Skills.get_skill_by_bind(player, "skill3")
	var skill4 = Skills.get_skill_by_bind(player, "skill4")
	
	if skill1 != null and player.skills.has(skill1["name"]):
		var skill = $"Control/Skill Bar/skill1"
		var stylebox = StyleBoxTexture.new()
		var img = load(skill1["img"]) 
		stylebox.texture = img
		skill.add_theme_stylebox_override("panel", stylebox)
		if not Skills.has_enough_sp(skill1["name"]):
			skill.get_node("TextureProgressBar").value = 100
		else:
			skill.get_node("TextureProgressBar").value = Skills.get_delay_left_percent(skill1["name"])
		
	elif skill2 != null and player.skills.has(skill2["name"]):
		var skill = $"Control/Skill Bar/skill2"
		var stylebox = StyleBoxTexture.new()
		var img = load(skill2["img"]) 
		stylebox.texture = img
		skill.add_theme_stylebox_override("panel", stylebox)
		if not Skills.has_enough_sp(skill2["name"]):
			skill.get_node("TextureProgressBar").value = 100
		else:
			skill.get_node("TextureProgressBar").value = Skills.get_delay_left_percent(skill1["name"])
	
	elif skill3 != null and player.skills.has(skill3["name"]):
		var skill = $"Control/Skill Bar/skill3"
		var stylebox = StyleBoxTexture.new()
		var img = load(skill3["img"]) 
		stylebox.texture = img
		skill.add_theme_stylebox_override("panel", stylebox)
		if not Skills.has_enough_sp(skill3["name"]):
			skill.get_node("TextureProgressBar").value = 100
		else:
			skill.get_node("TextureProgressBar").value = Skills.get_delay_left_percent(skill1["name"])
		
	elif skill4 != null and player.skills.has(skill1["name"]):
		var skill = $"Control/Skill Bar/skill4"
		var stylebox = StyleBoxTexture.new()
		var img = load(skill4["img"]) 
		stylebox.texture = img
		skill.add_theme_stylebox_override("panel", stylebox)
		if not Skills.has_enough_sp(skill4["name"]):
			skill.get_node("TextureProgressBar").value = 100
		else:
			skill.get_node("TextureProgressBar").value = Skills.get_delay_left_percent(skill1["name"])

func update_auto():
	var auto = $Control/Control/auto
	
	if player.current_job == player.JOB.MAGE:
		var stylebox = StyleBoxTexture.new()
		var img = load(Skills.skills["soul_strike"]["img"]) 
		stylebox.texture = img
		auto.add_theme_stylebox_override("panel", stylebox)
		auto.get_node("TextureProgressBar").value = Skills.get_delay_left_percent("soul_strike")
	
