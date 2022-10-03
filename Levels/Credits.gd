extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.set_process(false)
	Game.text_screen_ui.set_text("EXPERIMENTAL")
	Ui.to_credits()
	
	$CreditAnimation.play("credits")
	
	yield($CreditAnimation, "animation_finished")
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit(0)


func fade_out():
	Ui.get_node("CreditsAnimation").play("fade_credits_out")
