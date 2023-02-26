extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var card = $AchievementCard

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("achievement_completed", self, "_on_achievement_completed")


func _on_achievement_completed(ach: Achievement):
	visible = true
	card.texture = ach.achievement_card
	Events.emit_signal("game_paused", true)


func _on_CloseMenuButton_button_down():
	visible = false
	Events.emit_signal("game_paused", false)
