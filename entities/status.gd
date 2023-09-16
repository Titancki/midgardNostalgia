extends Node

signal on_status_updated
var endure_started = false

func endure(target):
	if target.skills.has("endure") and not endure_started:
		endure_started = true
		var delay = 10 - target.skills["endure"]["current_lvl"]
		await get_tree().create_timer(delay).timeout
		target.statuses.append("endure")
		emit_signal("on_status_updated")
		await get_tree().create_timer(5).timeout
		target.statuses.erase("endure")
		endure_started = false
		emit_signal("on_status_updated")
		
