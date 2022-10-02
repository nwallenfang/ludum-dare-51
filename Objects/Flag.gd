extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("dance")


func _on_Area_area_entered(area: Area) -> void:
	Game.load_next_level()
