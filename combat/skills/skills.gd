extends Node

enum JOB {NOVICE, SWORDMAN, ARCHER, MAGE, THIEF, ACOLYTE, MERCHANT}
var skills = {
	"pierce_arrow":{
		"name" = "Pierce Arrow",
		"description" = "Have 20% chance to pierce 1 target per level.",
		"max_lvl" = 5,
		"img"= "res://asset/icons/skills/ac_chargearrow.png",
		"pos" = "1_1",
		"job" = JOB.ARCHER,
		"bind" = null,
		"sp_cost" = 0,
	},
	"owls_eye":{
		"name" = "Owl's eye",
		"description" = "Improve your range by 5% per lvl",
		"max_lvl" = 10,
		"img"= "res://asset/icons/skills/ac_owl.png",
		"pos" = "3_1",
		"job" = JOB.ARCHER,
		"bind" = null,
		"sp_cost" = 0,
	},
	"inc_recovery":{
		"name" = "Increased  Recovery",
		"description" = "Heals yourself every 4 seconds for 0.5HP per lvl. Vitality increase healing effect by 10% per point",
		"max_lvl" = 5,
		"img"= "res://asset/icons/skills/sm_recovery.png",
		"pos" = "3_1",
		"job" = JOB.SWORDMAN,
		"bind" = null,
		"sp_cost" = 0,
	},
	"endure":{
		"name" = "Endure",
		"description" = "Allow you to avoid the bump effect when hit by enemies. 10% uptime per lvl",
		"max_lvl" = 10,
		"img"= "res://asset/icons/skills/endure.png",
		"pos" = "1_1",
		"job" = JOB.SWORDMAN,
		"bind" = null,
		"sp_cost" = 0,
	},
	"soul_strike":{
		"name" = "soul_strike",
		"description" = "Cast up to 5 ghost sphere wich deal 20% of your matk each",
		"max_lvl" = 5,
		"img"= "res://asset/icons/skills/mg_soulstrike.png",
		"pos" = "1_1",
		"job" = JOB.MAGE,
		"bind" = null,
		"sp_cost" = 0,
	},
	"fire_wall":{
		"name" = "fire_wall",
		"description" = "Cast a wall that last 2 second per lvl. High cooldown",
		"max_lvl" = 10,
		"img"= "res://asset/icons/skills/firewall.png",
		"pos" = "2_1",
		"job" = JOB.MAGE,
		"bind" = "skill1",
		"sp_cost" = 15,
	},
}

var soul_strike_scene = preload("res://combat/skills/soul_strike/scene.tscn")
var fire_wall_scene = preload("res://combat/skills/fire_wall/scene.tscn")

var callables = {
		"fire_wall" : null,
		"soul_strike" : null,
	}

func add_or_lvl_up(skill_name, player):
	if player.skills.has(skill_name):
		player.skills[skill_name]["current_lvl"] += 1	
	else:
		player.skills[skill_name] = {
			"current_lvl" = 1,
		}
		if skill_name == "fire_wall":
			callables["fire_wall"] = Fire_wall.new()
			callables["fire_wall"].player = player
		if skill_name == "soul_strike":
			callables["soul_strike"] = Soul_strike.new()
			callables["soul_strike"].player = player

func cast_skills():
	for callable in callables:
		if callables[callable] != null:
			callables[callable].update()

func get_delay_left(skill):
	return callables[skill].get_delay_left()
	
func get_delay_left_percent(skill):
	return callables[skill].get_delay_left_percent()
	
func has_enough_sp(skill):
	return callables[skill].has_enough_sp()

func get_skill_by_bind(player, bind):
	for skill in skills:
		if skills[skill]["job"] == player.current_job \
		and skills[skill]["bind"] == bind:
			return skills[skill]
	return null
