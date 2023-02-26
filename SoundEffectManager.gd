extends Node2D

export (Array, Resource) var sounds = []

var sfx_player = preload("res://SoundEffectPlayer.tscn")

func play_sound(id):
	if sounds[id]:
		var player = sfx_player.instance() as AudioStreamPlayer
		add_child(player)
		player.stream = sounds[id]
		player.play()
