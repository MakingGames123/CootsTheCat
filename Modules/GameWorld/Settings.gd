extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Cancel_button_down():
	visible = false


func _on_Quit_button_down():
	get_tree().change_scene("res://Modules/HomeScreen/HomeScreen.tscn")
