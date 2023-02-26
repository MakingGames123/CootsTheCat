extends Resource
class_name Achievement


export var name = "Name"
export var completed = false
export (Resource) var achievement_card


func complete_achievement():
	if completed != true:
		Events.emit_signal("achievement_completed", self)
		completed = true
