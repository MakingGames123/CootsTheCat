extends ReferenceRect


onready var texture_rect1 = $TextureRect1
onready var texture_progress_1 = $TextureRect1/TextureProgress
onready var texture_rect2 = $TextureRect2
onready var texture_progress_2 = $TextureRect2/TextureProgress

func _ready():
	Events.connect("stat_changed",self,"_on_stat_changed")


func _on_stat_changed(statID, value):
	if statID == 1:
		texture_progress_1.value += value
	else:
		texture_progress_2.value += value
	
