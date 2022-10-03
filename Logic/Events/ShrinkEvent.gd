extends Node

export var icon: Texture
export var event_name: String
export var size_multiplier: float


func event():
	$Tween.reset_all()
		
	$Tween.interpolate_property(Game.player, "scale", Game.player.scale, Game.player.default_scale - Vector3(size_multiplier, size_multiplier, size_multiplier), 1)
	$Tween.interpolate_property(Game.player, "speed", Game.player.speed, 30, 1)
	
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	print("shrink event", event_name)

func end_event():
	$Tween.reset_all()
		
	$Tween.interpolate_property(Game.player, "scale", Game.player.scale, Game.player.default_scale, 0.5)
	$Tween.interpolate_property(Game.player, "speed", Game.player.speed, 10, 1)
	
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	print("End shrink event", event_name)
