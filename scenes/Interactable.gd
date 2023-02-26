extends Node2D

var interactable = false
var used = false

onready var sprite = $Sprite

signal increase_stat(stat, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	if interactable:
		sprite.rotation_degrees = 45
	else:
		sprite.rotation_degrees = 0

func _on_StaticBody2D_area_entered(area):
	print(area.name)
	print(area.name == "InteractionArea")
	if(area.name == "InteractionArea"): #FIXME
		interactable = true


func _on_StaticBody2D_area_exited(area):
	print("exited")
	if(area.name == "InteractionArea"): #FIXME
		interactable = false
		used = false


func _on_Coots_interacted():
	sprite.rotation_degrees = -45
	interactable = false
	if not used:
		Events.emit_signal("stat_changed",1,10)
		used = true
