extends Spatial
class_name Enemy

export var health := 10

func _ready():
	pass

func damage(amount: int):
	health -= amount
	if health <= 0:
		self.queue_free()
		
	#TODO: Call damage and death sounds
