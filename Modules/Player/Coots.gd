extends KinematicBody2D


enum {
	MOVING,
	INTERACT,
	SLEEPING,
	IDLING,
	WHACKING,
	CONSUMING
}


var state = IDLING
var sleepy = false

export var MAX_SPEED = 60
export var ACCELERATION = 500
export var DODGE_SPEED = 125
export var FRICTION = 500
var velocity = Vector2.ZERO


onready var sprite = $SpriteHolder
onready var animTree = $AnimationTree
onready var animationState = animTree.get("parameters/playback")
onready var animPlayer = $AnimationPlayer
onready var statBar1 = $StatBar
onready var statBar2 = $StatBar1

var stat1 = 0
var stat2 = 0

signal interacted
signal whacked

var paused = false

var meowTimer = Timer.new()
var canMeow = true
export var meowTime = 2

export (Array, Resource) var possibleAchievements

func _ready():
	animTree.active = true

	meowTimer.one_shot = true
	meowTimer.wait_time = meowTime
	meowTimer.connect("timeout", self, "_on_meow_timer_timeout")
	add_child(meowTimer)
	
	Events.connect("day_ended",self,"_on_day_ended")
	Events.connect("game_paused", self, "_on_pause")
	
	Events.connect("stat_changed",self,"_on_Interactable_increase_stat")
	
	$UiSleepy.visible = false
	

func _physics_process(delta):
	if stat1 >= 50:
		var ach = possibleAchievements[1] as Achievement
		ach.complete_achievement()
	if stat2 >= 50:
		var ach = possibleAchievements[0] as Achievement
		ach.complete_achievement()
	if !paused:
		if state == IDLING or state == MOVING:
			move(delta)
		handle_action_inputs()
		animation_update()
		

func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()

	
	if Input.is_action_pressed("ui_right"):
		_coots_change_direction(-1)
	if Input.is_action_pressed("ui_left"):
		_coots_change_direction(1)
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		state = MOVING
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		state = IDLING

	velocity = move_and_slide(velocity)


func animation_update():
	match state:
			MOVING:
				animationState.travel("Walking")
				if meowTimer.time_left > 0:
					$SpriteHolder/Sprite/CootsWalkMeow.visible = true
					$SpriteHolder/Sprite/CootsIdleMeow.visible = false
			IDLING:
				if meowTimer.time_left > 0:
					$SpriteHolder/Sprite/CootsWalkMeow.visible = false
					$SpriteHolder/Sprite/CootsIdleMeow.visible = true
				animationState.travel("Idle")
	if sleepy:
		$UiSleepy.visible = true
			
				
func handle_action_inputs():
	if Input.is_action_just_pressed("meow") && meowTimer.time_left == 0:
		do_meow()
	if state == IDLING:
		if Input.is_action_just_pressed("whack"):
			print("whack input registered")
			do_whack()
	if Input.is_action_just_pressed("interact"):
		print("interact input registered")
		emit_signal("interacted")

#func check_for_state_independant_actions():
#	if Input.is_action_just_pressed("meow"):
#		print("we meowing 2night")
#		do_meow()
#		match state:
#			MOVE:
#				$SpriteHolder/Sprite/CootsWalkMeow.visible = true

func interact_state(delta):
	animationState.travel("IdleWhack")

func move_state(delta):
	update_stats_display()

func _on_day_ended():
	sleepy = true

func update_stats_display():
	statBar1.value = stat1
	statBar2.value = stat2


func _on_Interactable_increase_stat(stat, value):
	print("stat increased")
	if stat == 1:
		stat1 += value
	if stat == 2:
		stat2 += value
		
func _on_oneshot_animation_end():
	state=IDLING
	$SpriteHolder/Sprite/CootsConsumeFood.visible = false
	$SpriteHolder/Sprite/CootsConsumeWater.visible = false

func _on_InteractionArea_area_entered(area):
	pass


func initiate_sleep_transition():
	state = SLEEPING
	sleepy = false
	$UiSleepy.visible = false
	animationState.travel("Sleep")
	Events.emit_signal("reset_day")

func initiate_consume_transition(isFood):
	state = CONSUMING
	animationState.travel("Consume")
	if isFood:
		$SpriteHolder/Sprite/CootsConsumeFood.visible = true
	else:
		$SpriteHolder/Sprite/CootsConsumeWater.visible = true

func _on_pause(isPaused):
	paused = isPaused

func do_whack():
	state = WHACKING
	animationState.travel("IdleWhack")
	emit_signal("whacked")

func do_meow():
	print("doing meow stuff")
	SoundEffectManager.play_sound(2)
	meowTimer.start()
	canMeow = false
	
func _on_meow_timer_timeout():
	$SpriteHolder/Sprite/CootsWalkMeow.visible = false
	$SpriteHolder/Sprite/CootsIdleMeow.visible = false
	canMeow = true


func _coots_change_direction(scale):
	sprite.scale.x = scale
	$InteractionArea.scale.x = scale
