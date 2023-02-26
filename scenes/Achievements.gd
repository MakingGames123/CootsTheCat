extends Node2D

var criteria_list = [
	{
		"ID": 1,
		"name": "Survive a day",
		"completed": false
	},
	{
		"ID": 2,
		"name": "Meow For 30 sec",
		"completed": false
	}
]

var achievements_list = [
	{
		"ID": 1,
		"name": "Survive a day",
		"criteria_required": [1],
		"completed": false
	},
	{
		"ID": 1,
		"name": "Meow for 30 sec",
		"criteria_required": [2],
		"completed": false
	}
]

export(Array, Resource) var achievements



# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("critera_accomplished",self,"_on_criteria_accomplished")
	Events.connect("achievement_completed", self, "_on_achievement_completed")


func check_for_completed_achievements():
	for achievement in achievements_list:
		for req_criteria_id in achievement.get("criteria_required"):
				for criteria in criteria_list:
					if criteria.get("ID") == req_criteria_id:
						pass
						

func _on_criteria_accomplished(id):
	for ach in achievements:
		var achievement = ach as Achievement
		achievement.complete_achievement()

func _on_achievement_completed(ach: Achievement):
	SoundEffectManager.play_sound(0)
	print(ach.name + " Completed !!!!!")
