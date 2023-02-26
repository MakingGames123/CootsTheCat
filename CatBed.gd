extends Sprite


onready var light = $Light

var coots_in_range = false
var enabled = false
var coots_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("day_ended",self,"_on_day_ended")

func _on_day_ended():
	light.visible = true
	enabled = true


func _on_Area2D_area_entered(area):
#	print(area.get_parent().name)
	if area.get_parent().name == "Coots":
		coots_scene = area.get_parent()
		coots_scene.connect("interacted", self, "_coots_interacted")
	if(area.name == "InteractionArea"):
		coots_in_range = true



func _on_Area2D_area_exited(area):
	print("exited")
	if(area.name == "InteractionArea"): #FIXME
		coots_in_range = false
		
func _coots_interacted():
	if enabled and coots_in_range:
		coots_scene.global_position = $Location.global_position
		print(coots_scene.global_position)
		print($Location.global_position)
		coots_scene.initiate_sleep_transition()
