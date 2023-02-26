extends AudioStreamPlayer

export (Array, Resource) var sounds = []

func _ready():
	connect("finished", self, "_on_finished")

func play_sound(sound_to_play):
	stream = sound_to_play
	play()
	
func _on_finished():
	queue_free()
