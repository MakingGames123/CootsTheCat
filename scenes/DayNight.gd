extends CanvasModulate

enum {
	MORNING=1,
	DAY=2,
	NIGHT=3,
}


export var MORNING_COLOR = Color("e6cbac")
export var DAY_COLOR = Color("ffffff")
export var EVENING_COLOR = Color("ffffff")
export var NIGHT_COLOR = Color("10100f")



export (Array, Resource) var lights

var time = 0.0

const TIME_SCALE = 0.1

func set_time(value: float):
	time = value

func change_time_of_day():
	self.color = DAY_COLOR

func disable_lights():
	$LightEffects/BgLightingWindowDay.modulate.a = 0
	$LightEffects/BgLightingPcNight.modulate.a = 0
	$LightEffects/BgLightingWindowNight.modulate.a = 0
	$LightEffects/BgLightingWindowEvening.modulate.a = 0

func _ready():
	disable_lights()
	self.color = MORNING_COLOR
	Events.connect("time_of_day_change",self, "change_time_of_day")

func _physics_process(delta: float) -> void:
	if time <= 0.25:
		var normed_time = inverse_lerp(0, 0.25, time)
		self.color = MORNING_COLOR.linear_interpolate(DAY_COLOR, normed_time)
		var alpha_value = inverse_lerp(0, 0.25, time)
		print(alpha_value)
		$LightEffects/BgLightingWindowMorning.modulate.a = 0.4 - normed_time*0.4
		$LightEffects/BgLightingWindowDay.visible = true
		$LightEffects/BgLightingWindowDay.modulate.a = normed_time
	if time >0.25 and time <= 0.5:
		var normed_time = inverse_lerp(0.25, 0.5, time)
		self.color = DAY_COLOR.linear_interpolate(EVENING_COLOR, normed_time)
		$LightEffects/BgLightingWindowDay.modulate.a = 1 - normed_time
		$LightEffects/BgLightingWindowEvening.visible = true
		$LightEffects/BgLightingWindowEvening.modulate.a = normed_time
	if time >0.5 and time <= 0.75:
		var normed_time = inverse_lerp(0.5, 0.75, time)
		self.color = EVENING_COLOR.linear_interpolate(NIGHT_COLOR, normed_time)
		$LightEffects/BgLightingWindowEvening.modulate.a = 1 - normed_time
		$LightEffects/BgLightingWindowNight.visible = true
		$LightEffects/BgLightingPcNight.modulate.a = 1
		$LightEffects/BgLightingPcNight.visible = true
		$LightEffects/BgLightingWindowNight.modulate.a = normed_time
		
	

