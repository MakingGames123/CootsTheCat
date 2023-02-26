extends KinematicBody2D

onready var light = $Light

var coots_in_range = false
var enabled = true
var coots_scene


var interactDelayTimer = Timer.new()
export var interactDelayTime = 3

export (Array, Resource) var possibleAchievements 

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("day_ended",self,"_on_day_ended")
	$Area2D.connect("area_entered", self,"_on_Area2D_area_entered")
	$Area2D.connect("area_exited", self,"_on_Area2D_area_exited")
	
	interactDelayTimer.one_shot = true
	interactDelayTimer.wait_time = interactDelayTime
	interactDelayTimer.connect("timeout", self, "_on_interactDelayTimer_timer_timeout")
	add_child(interactDelayTimer)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Reflect the object's velocity based on the collision normal
		velocity = velocity.bounce(collision.normal)
	
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)

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
	enabled = true


func _on_Area2D_area_exited(area):
	print("exited")
	if(area.name == "InteractionArea"): #FIXME
		coots_in_range = false


func _coots_whacked():
	if enabled and coots_in_range:
		# Get the direction from the player to this object
		var direction = global_position - coots_scene.global_position

		# Normalize the direction vector
		direction = direction.normalized()

		# Set the speed at which the object will fly away
		var speed = 300
		velocity = direction * speed
		move_and_slide(velocity)
		
func _coots_interacted():
	pass
#	if enabled and coots_in_range and interactDelayTimer.time_left ==0:
#		interactDelayTimer.start()
#		friendlyInteractionsHappened +=1
#		enabled = false
#		UINice.visible = true

