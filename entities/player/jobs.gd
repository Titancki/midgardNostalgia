extends Node

enum JOB {NOVICE, SWORDMAN, ARCHER, MAGE, THIEF, ACOLYTE, MERCHANT}

var attributes = [
	# NOVICE
	{
		"attack_delay" : 0.7,
		"max_hp" : 36.0,
		"max_sp" : 10.0,
		"sp_regen": 1,
		"phy_m_damage" : 2.0,
		"phy_d_damage" : 2.0,
		"magic_damage" : 2.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
	# SWORDMAN
	{
		"attack_delay" : 0.7,
		"max_hp" : 55.0,
		"max_sp" : 10.0,
		"sp_regen": 1,
		"phy_m_damage" : 3.0,
		"phy_d_damage" : 2.0,
		"magic_damage" : 2.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
	# ARCHER
	{
		"attack_delay" : 0.7,
		"max_hp" : 36.0,
		"max_sp" : 10.0,
		"sp_regen": 1,
		"phy_m_damage" : 2.0,
		"phy_d_damage" : 7.0,
		"magic_damage" : 2.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
	# MAGE
	{
		"attack_delay" : 0.7,
		"max_hp" : 36.0,
		"max_sp" : 36.0,
		"sp_regen": 1,
		"phy_m_damage" : 2.0,
		"phy_d_damage" : 2.0,
		"magic_damage" : 10.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
	# THIEF
	{
		"attack_delay" : 0.7,
		"max_hp" : 36.0,
		"max_sp" : 10.0,
		"sp_regen": 1,
		"phy_m_damage" : 2.0,
		"phy_d_damage" : 2.0,
		"magic_damage" : 2.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
	# ACOLYTE
	{
		"attack_delay" : 0.7,
		"max_hp" : 36.0,
		"max_sp" : 10.0,
		"sp_regen": 1,
		"phy_m_damage" : 2.0,
		"phy_d_damage" : 2.0,
		"magic_damage" : 2.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
	# MERCHANT
	{
		"attack_delay" : 0.7,
		"max_hp" : 36.0,
		"max_sp" : 10.0,
		"sp_regen": 1,
		"phy_m_damage" : 2.0,
		"phy_d_damage" : 2.0,
		"magic_damage" : 2.0,
		"crit_chance" : 0,
		"block": 0,
		"speed": 4,
	},
]

func get_animated_body(player):
	var animated_novice = player.get_node("AnimatedBodies/Novice")
	var animated_swordman = player.get_node("AnimatedBodies/Swordman")
	var animated_archer = player.get_node("AnimatedBodies/Archer")
	var animated_mage = player.get_node("AnimatedBodies/Mage")
	var animations = [animated_novice, animated_swordman, animated_archer, animated_mage]
	
	for animation in animations:
		animation.hide()
	animations[player.current_job].show()
	return animations[player.current_job]

func update_attributes(player):
	#"str"
	player.attributes["phy_m_damage"] = attributes[player.current_job]["phy_m_damage"]  * (1 + 0.10 * player.stats["str"])
	#"vit"
	player.attributes["max_hp"] = round(attributes[player.current_job]["max_hp"]  * (1 + 0.02 * player.stats["vit"]))
	player.attributes["block"] = 0.01 * player.stats["vit"]
	if player.skills.has("inc_recovery"):
		player.attributes["recovery"] = round((player.skills["inc_recovery"]["current_lvl"]* 0.5) * 
		(1 + 0.1 * player.stats["vit"]))
	#"dex"
	player.attributes["cdr"] = 1- (0.01 * player.stats["dex"])
	player.attributes["phy_d_damage"] = attributes[player.current_job]["phy_d_damage"]  * (1 + 0.10 * player.stats["dex"])
	#"agi"
	player.attributes["attack_delay"] = (attributes[player.current_job]["attack_delay"]  *  (1 - 0.01 * player.stats["agi"])) + 0.2
	player.speed = attributes[player.current_job]["speed"] + 0.04 * player.stats["agi"]
	#"int"
	player.attributes["magic_damage"] = attributes[player.current_job]["magic_damage"]  * (1 + 0.10 * player.stats["int"])
	player.attributes["max_sp"] = round(attributes[player.current_job]["max_sp"]  * (1 + 0.02 * player.stats["int"]))
	player.attributes["sp_regen"] = attributes[player.current_job]["sp_regen"] + (player.stats["int"]/3)
	#"luk"
	player.attributes["crit_chance"] = 0.01 * player.stats["luk"]
