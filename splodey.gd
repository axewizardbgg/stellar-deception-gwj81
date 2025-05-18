extends Node2D

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# First let's randomize our rotation
	rotation = randf() * TAU
	
	# Now let's set up a Tween to fade out and reduce our scale
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(func (): queue_free())
	
