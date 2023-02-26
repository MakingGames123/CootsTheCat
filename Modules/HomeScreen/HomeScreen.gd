extends Control


var loadingScreen = preload("res://Modules/LoadingScreen/LoadingScreen.tscn")

onready var ScreenHolder = $ScreenHolder

func _ready():
	$Menu/StartButton.grab_focus()
	


func _on_options_button_pressed():
	pass


func _on_exit_button_pressed():
	pass
	get_tree().quit()


func _on_credits_button_pressed():
	pass


func _on_StartButton_button_down():
	pass
#	get_tree().change_scene("res://Modules/LoadingScreen/LoadingScreen.tscn")
	


func _on_Start_button_down():
	get_tree().change_scene("res://Modules/LoadingScreen/LoadingScreen.tscn")


func _on_Credits_button_down():
	get_tree().change_scene("res://Modules/Credits/Credits.tscn")
