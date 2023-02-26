extends TextureRect



# Called when the node enters the scene tree for the first time.
func _ready():
	var Ti = Timer.new()
	Ti.autostart = true
	Ti.one_shot = true
	Ti.wait_time = 4
	Ti.connect("timeout", self, "end_loading")
	add_child(Ti)
	Ti.start()

func _physics_process(delta):
	if Input.is_action_just_pressed("meow"):
		get_tree().change_scene("res://Modules/GameWorld/World.tscn")

func end_loading():
	print("ended loading")
	get_tree().change_scene("res://Modules/GameWorld/World.tscn")
