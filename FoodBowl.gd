extends Sprite


onready var light = $Light

var coots_in_range = false
var enabled = true
var coots_scene

export var isFood = true

export var interactsLeftForAchievement = 1

export (Array, Resource) var possibleAchievements
export (Array, Resource) var possibleSprites 


var interactDelayTimer = Timer.new()
export var interactDelayTime = 1.5


# Called when the node enters the scene tree for the first time.
func _ready():
	if isFood:
		texture = possibleSprites[0]
	else:
		texture = possibleSprites[1]
	enabled = true
	Events.connect("day_ended",self,"_on_day_ended")
	$Area2D.connect("area_entered", self,"_on_Area2D_area_entered")
	$Area2D.connect("area_exited", self,"_on_Area2D_area_exited")
	
	interactDelayTimer.one_shot = true
	interactDelayTimer.wait_time = interactDelayTime
	interactDelayTimer.connect("timeout", self, "_on_interactDelayTimer_timer_timeout")
	add_child(interactDelayTimer)

func _physics_process(delta):
	if interactsLeftForAchievement <=0:
		if isFood:
			var ach = possibleAchievements[0] as Achievement
			ach.complete_achievement()
			enabled = false
		else:
			var ach = possibleAchievements[1] as Achievement
			ach.complete_achievement()
			enabled = false

func _on_day_ended():
	enabled = false


func _on_Area2D_area_entered(area):
#	print(area.get_parent().name)
	if area.get_parent().name == "Coots":
		coots_scene = area.get_parent()
		coots_scene.connect("interacted", self, "_coots_interacted")
	if(area.name == "InteractionArea"):
		coots_in_range = true

func _on_interactDelayTimer_timer_timeout():
	enabled = true

func _on_Area2D_area_exited(area):
	print("exited")
	if(area.name == "InteractionArea"): #FIXME
		coots_in_range = false
		
func _coots_interacted():
	if enabled and coots_in_range:
		interactDelayTimer.start()
		enabled = false
		interactsLeftForAchievement-=1
		if coots_scene.global_position.x >= global_position.x:
			coots_scene.global_position = $Location.global_position
			coots_scene._coots_change_direction(1)
		else:
			coots_scene.global_position = $Location2.global_position
			coots_scene._coots_change_direction(-1)
		print(coots_scene.global_position)
		print($Location.global_position)
		coots_scene.initiate_consume_transition(isFood)
