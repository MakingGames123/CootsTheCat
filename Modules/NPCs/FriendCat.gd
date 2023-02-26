extends Sprite


onready var light = $Light

var coots_in_range = false
var enabled = true
var coots_scene

onready var UINice = $UiNice
onready var UINaughty = $UiNaughty

export var friendlyInteractionsHappened = 0
export var friendlyInteractionsNeeded = 3

export var naughtyInteractionsHappened = 0
export var naughtyInteractionsNeeded = 3


var interactDelayTimer = Timer.new()
export var interactDelayTime = 3

export (Array, Resource) var possibleAchievements 

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("day_ended",self,"_on_day_ended")
	$Area2D.connect("area_entered", self,"_on_Area2D_area_entered")
	$Area2D.connect("area_exited", self,"_on_Area2D_area_exited")
	UINice.visible = false
	UINaughty.visible = false
	
	interactDelayTimer.one_shot = true
	interactDelayTimer.wait_time = interactDelayTime
	interactDelayTimer.connect("timeout", self, "_on_interactDelayTimer_timer_timeout")
	add_child(interactDelayTimer)

func _physics_process(delta):
	if friendlyInteractionsHappened >= friendlyInteractionsNeeded:
		var ach = possibleAchievements[0] as Achievement
		ach.complete_achievement()
	if naughtyInteractionsHappened >= naughtyInteractionsNeeded:
		pass
#		var ach = possibleAchievements[1] as Achievement
#		ach.complete_achievement()

func _on_day_ended():
	enabled = false


func _on_Area2D_area_entered(area):
#	print(area.get_parent().name)
	if area.get_parent().name == "Coots":
		coots_scene = area.get_parent()
		coots_scene.connect("interacted", self, "_coots_interacted")
		coots_scene.connect("whacked", self, "_coots_whacked")
	if(area.name == "InteractionArea"):
		coots_in_range = true


func _on_interactDelayTimer_timer_timeout():
	UINice.visible = false
	UINaughty.visible = false
	enabled = true


func _on_Area2D_area_exited(area):
	print("exited")
	if(area.name == "InteractionArea"): #FIXME
		coots_in_range = false

func _coots_whacked():
	if enabled and coots_in_range and interactDelayTimer.time_left ==0:
		interactDelayTimer.start()
		naughtyInteractionsHappened +=1
		enabled = false
		UINaughty.visible = true
		Events.emit_signal("stat_changed",1,20)
		SoundEffectManager.play_sound(1)
		
func _coots_interacted():
	if enabled and coots_in_range and interactDelayTimer.time_left ==0:
		interactDelayTimer.start()
		friendlyInteractionsHappened +=1
		enabled = false
		UINice.visible = true
		Events.emit_signal("stat_changed",2,10)
