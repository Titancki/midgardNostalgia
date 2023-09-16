extends Control

@onready var player = get_tree().root.get_node("TestWorld/Player")
var damage

func _process(_delta):
	if Input.is_action_just_pressed("menu_pause"):
		queue_free()
	if player.current_job in [player.JOB.ARCHER]:
		damage = player.attributes["phy_d_damage"]
	else:
		damage = player.attributes["phy_m_damage"]
	$TabBar/Stats/HBoxContainer/VBoxContainer2/HPBox/Value.text = str(player.attributes["max_hp"])
	$TabBar/Stats/HBoxContainer/VBoxContainer2/DamageBox/Value.text = str(damage)
	$TabBar/Stats/HBoxContainer/VBoxContainer2/MagicDamageBox/Value.text = str(player.attributes["magic_damage"])
	$TabBar/Stats/HBoxContainer/VBoxContainer2/AfterAttackDelayBox/Value.text = str(player.attributes["attack_delay"])
	$TabBar/Stats/HBoxContainer/VBoxContainer2/CritChanceBox/Value.text = str(player.attributes["crit_chance"] * 100, "%")
	$TabBar/Stats/HBoxContainer/VBoxContainer2/BlockBox/Value.text = str(player.attributes["block"] * 100, "%")
	
	$TabBar/Stats/HBoxContainer/VBoxContainer/StrBox/Value.text = str(player.stats["str"])
	$TabBar/Stats/HBoxContainer/VBoxContainer/VitBox/Value.text = str(player.stats["vit"])
	$TabBar/Stats/HBoxContainer/VBoxContainer/DexBox/Value.text = str(player.stats["dex"])
	$TabBar/Stats/HBoxContainer/VBoxContainer/AgiBox/Value.text = str(player.stats["agi"])
	$TabBar/Stats/HBoxContainer/VBoxContainer/IntBox/Value.text = str(player.stats["int"])
	$TabBar/Stats/HBoxContainer/VBoxContainer/LuckBox/Value.text = str(player.stats["luk"])
	
	set_skills()

func set_skills():
	var skills = Skills.skills
	var btns = {
		"1_1" = $"TabBar/Skills/HBoxContainer/col-1/row-1",
		"1_2" = $"TabBar/Skills/HBoxContainer/col-1/row-2",
		"1_3" = $"TabBar/Skills/HBoxContainer/col-1/row-3",
		"2_1" = $"TabBar/Skills/HBoxContainer/col-2/row-1",
		"2_2" = $"TabBar/Skills/HBoxContainer/col-2/row-2",
		"2_3" = $"TabBar/Skills/HBoxContainer/col-2/row-3",
		"3_1" = $"TabBar/Skills/HBoxContainer/col-3/row-1",
		"3_2" = $"TabBar/Skills/HBoxContainer/col-3/row-2",
		"3_3" = $"TabBar/Skills/HBoxContainer/col-3/row-3",
	}
	for skill in skills:
		if player.current_job == skills[skill]["job"]:
		
			var btn = btns[skills[skill]["pos"]]
			var stylebox = StyleBoxTexture.new()
			var img = load(skills[skill]["img"]) 
			stylebox.texture = img
			btn.add_theme_stylebox_override("normal", stylebox)
			btn.disabled = false
		
		if Input.is_action_just_pressed("menu_pause") and get_node_or_null("PauseInterface") == null:
			$"TabBar/Skills/HBoxContainer/Tooltip/VBoxContainer/HBoxContainer/Skill Name".text = ""
			$TabBar/Skills/HBoxContainer/Tooltip/VBoxContainer/HBoxContainer/Level.text = ""
			$TabBar/Skills/HBoxContainer/Tooltip/VBoxContainer/Description.text = ""
		
func set_skill_tooltip(pos):
	var skills = Skills.skills
	for skill in skills:
		if skills[skill]["pos"] == pos and player.current_job == skills[skill]["job"]:
					$"TabBar/Skills/HBoxContainer/Tooltip/VBoxContainer/HBoxContainer/Skill Name".text = skills[skill]["name"]
					var lvl
					if player.skills.has(skill):
						lvl = str("Lvl ", player.skills[skill]["current_lvl"], " / ", skills[skill]["max_lvl"])
					else:
						lvl = str("Lvl 0 / ", skills[skill]["max_lvl"])
					$TabBar/Skills/HBoxContainer/Tooltip/VBoxContainer/HBoxContainer/Level.text = lvl
					$TabBar/Skills/HBoxContainer/Tooltip/VBoxContainer/Description.text = skills[skill]["description"]
				
func _on_job_1_1_pressed():
	set_skill_tooltip("1_1")

func _on_job_1_2_pressed():
	set_skill_tooltip("1_2")

func _on_job_1_3_pressed():
	set_skill_tooltip("1_3")

func _on_job_2_1_pressed():
	set_skill_tooltip("2_1")

func _on_job_2_2_pressed():
	set_skill_tooltip("2_2")

func _on_job_2_3_pressed():
	set_skill_tooltip("2_3")

func _on_job_3_1_pressed():
	set_skill_tooltip("3_1")

func _on_job_3_2_pressed():
	set_skill_tooltip("3_2")

func _on_job_3_3_pressed():
	set_skill_tooltip("3_3")
