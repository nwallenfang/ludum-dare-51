extends Node

export var icon: Texture
export var event_name: String
export var size_multiplier: float
var is_pickup

func _ready():
	set_process(false)
	
func _process(_delta):
	if $Tween.is_active():
		if Game.player.is_on_ceiling():
			$Tween.set_speed_scale(0)
		else:
			$Tween.set_speed_scale(1)

func event():
	$Tween.reset_all()
		
	$Tween.interpolate_property(Game.player, "scale", Game.player.scale, Game.player.default_scale - Vector3(size_multiplier, size_multiplier, size_multiplier), 1)
	$Tween.interpolate_property(Game.player, "speed", Game.player.speed, 30, 1)
	
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	print("shrink event", event_name)

func end_event():
	if is_pickup and Events.current_event.event_name == self.event_name:
		return
	if !is_pickup:
		for event in Events.pickup_stack:
			if event.event_name == self.event_name:
				return
	
	set_process(true)
	$Tween.reset_all()
		
	$Tween.interpolate_property(Game.player, "scale", Game.player.scale, Game.player.default_scale, 0.5)
	$Tween.interpolate_property(Game.player, "speed", Game.player.speed, 10, 1)
	
	$Tween.start()
	
#	while $Tween.is_active():
#		if Game.player.is_on_ceiling():
#			$Tween.stop_all()
	
	yield($Tween, "tween_all_completed")
	set_process(false)
	print("End shrink event", event_name)
