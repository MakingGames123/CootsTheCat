extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


func _on_options_button_pressed():
	pass


func _on_exit_button_pressed():
	pass
	get_tree().quit()


func _on_credits_button_pressed():
	pass


func _on_StartButton_button_down():
	get_tree().change_scene("res://Modules/LoadingScreen/LoadingScreen.tscn")


func _on_Button2_button_down():
	OS.shell_open("https://bio.link/jeidoll")


func _on_Button3_button_down():
	get_tree().change_scene("res://Modules/HomeScreen/HomeScreen.tscn")
