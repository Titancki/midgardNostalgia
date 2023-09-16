extends Node

enum JOB {NOVICE, SWORDMAN, ARCHER, MAGE, THIEF, ACOLYTE, MERCHANT}
var upgrades = {
	"up_str" : {
		"id": "up_str",
		"description" : "+1 Strength",
		"class_condition": null,
		"is_skill": false,
	},
	"up_vit" : {
		"id": "up_vit",
		"description" : "+1 Vitality",
		"class_condition": null,
		"is_skill": false,
	},
	"up_dex" : {
		"id": "up_dex",
		"description" : "+1 Dexterity",
		"class_condition": null,
		"is_skill": false,
	},
	"up_agi" : {
		"id": "up_agi",
		"description" : "+1 Agility",
		"class_condition": null,
		"is_skill": false,
	},
	"up_int" : {
		"id": "up_int",
		"description" : "+1 Intelligence",
		"class_condition": null,
		"is_skill": false,
	},
	"up_luk" : {
		"id": "up_luk",
		"description" : "+1 Luck",
		"class_condition": null,
		"is_skill": false,
	},
	"pierce_arrow":{
		"id": "pierce_arrow",
		"description" : "Pierce Arrow",
		"class_condition": JOB.ARCHER,
		"is_skill": true,
	},
	"owls_eye":{
		"id": "owls_eye",
		"description" : "Owl's Eye",
		"class_condition": JOB.ARCHER,
		"is_skill": true,
	},
	"inc_recovery":{
		"id": "inc_recovery",
		"description" : "Increased Recovery",
		"class_condition": JOB.SWORDMAN,
		"is_skill": true,
	},
	"endure":{
		"id": "endure",
		"description" : "Endure",
		"class_condition": JOB.SWORDMAN,
		"is_skill": true,
	},
	"soul_strike":{
		"id": "soul_strike",
		"description" : "Soul Strike",
		"class_condition": JOB.MAGE,
		"is_skill": true,
	},
	"fire_wall":{
		"id": "fire_wall",
		"description" : "Fire Wall",
		"class_condition": JOB.MAGE,
		"is_skill": true,
	},
}


func apply_effect(upgrade, player):
	if upgrade["is_skill"]:
		Skills.add_or_lvl_up(upgrade["id"], player)
	else:
		if upgrade == upgrades["up_str"]:
			player.stats["str"] += 1
		elif upgrade == upgrades["up_vit"]:
			player.stats["vit"] += 1
		elif upgrade == upgrades["up_dex"]:
			player.stats["dex"] += 1
		elif upgrade == upgrades["up_agi"]:
			player.stats["agi"] += 1
		elif upgrade == upgrades["up_int"]:
			player.stats["int"] += 1
		elif upgrade == upgrades["up_luk"]:
			player.stats["luk"] += 1

func get_available_upgrades(player) :
	var avalaible_upgrades = []
	
	for upgrade in upgrades:
		
		if upgrades[upgrade]["class_condition"] == null or \
		upgrades[upgrade]["class_condition"] == player.current_job :
			
			if not upgrades[upgrade]["is_skill"] :
				avalaible_upgrades.append(upgrades[upgrade])
		
			elif upgrades[upgrade]["is_skill"] :
				if player.skills.has(upgrade) :
					if player.skills[upgrade]["current_lvl"] < Skills.skills[upgrade]["max_lvl"]:
						avalaible_upgrades.append(upgrades[upgrade])
				elif not player.skills.has(upgrade):
					avalaible_upgrades.append(upgrades[upgrade])
	return avalaible_upgrades

func get_3_upgrades(player):
	var avalaible_upgrades = get_available_upgrades(player)
	var upgrade_choices = []
	
	while upgrade_choices.size() != 3:
		var index = randi() % avalaible_upgrades.size()
		upgrade_choices.append(avalaible_upgrades[index])
		avalaible_upgrades.erase(avalaible_upgrades[index])
	
	return upgrade_choices
