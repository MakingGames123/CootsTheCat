extends Node2D

export var dayInSeconds = 0

export (Array, Resource) var sounds_for_manager


onready var textArea = $UILayer/UI/RichTextLabel
onready var day_timer = $DayTimer
onready var canvas_modulate = $CanvasModulate

export (Array, Resource) var possibleAchievements 

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundEffectManager.sounds = sounds_for_manager
	day_timer.wait_time = dayInSeconds
	day_timer.start()
	day_timer.connect("timeout",self,"on_timer_timeout")
	Events.connect("reset_day",self, "_on_day_reset")
	Events.connect("game_paused", self, "_on_pause")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Events.emit_signal("game_paused", true)
		$UILayer/UI/Settings.visible = true
	var normalized_value = inverse_lerp(0, dayInSeconds, dayInSeconds-day_timer.time_left)
	canvas_modulate.set_time(normalized_value)
	textArea.text = normalized_value as String
	
func _input(event):
	pass

func on_timer_timeout():
	day_timer.stop()
	Events.emit_signal("day_ended")
	var ach = possibleAchievements[0] as Achievement
	ach.complete_achievement()


func _on_day_reset():
	var Ti = Timer.new()
	Ti.autostart = true
	Ti.one_shot = true
	Ti.wait_time = 2
	Ti.connect("timeout", self, "reset_game")
	add_child(Ti)

func reset_game():
	var ach = possibleAchievements[0] as Achievement
	get_tree().reload_current_scene()
	
	
func _on_pause(isPaused):
	day_timer.paused=isPaused
	paused = isPaused


func _on_Restart_button_down():
	get_tree().reload_current_scene()
	$UILayer/UI/Settings.visible = false


func _on_Quit_button_down():
	pass # Replace with function body.
