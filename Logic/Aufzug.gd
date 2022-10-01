extends Node

export var target_translation: Vector3
export var duration: float = 1

var target: Vector3

onready var parent = get_parent()

func _ready():
	while true:
		print("A")
		$Tween.reset_all()
		
		$Tween.interpolate_property(self, "translation", self.translation, self.translation + target_translation, duration)
		
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		
		yield(get_tree().create_timer(2), "timeout")
		
		print("B")
		
		$Tween.reset_all()
		
		$Tween.interpolate_property(self, "translation", self.translation, self.translation - target_translation, duration)
		
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		
		yield(get_tree().create_timer(2), "timeout")
