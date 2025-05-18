extends Control

signal intro_finished

# Called when the node enters the scene tree for the first time
func _ready():
	# Play our animation
	$AnimationPlayer.play("Intro")
	# Connect our complete method for when the animation completes
	$AnimationPlayer.animation_finished.connect(_complete)

# Check if the player wants to skip
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("activate"):
		# Players wants to skip
		Snd.play("click")
		_complete("")

# When the animation is done (either naturally or skipped), emit signal and destroy ourselves
# Note: We have the _animationName because the signal we connect it to has an argument and
# Godot complains and it fails to work if it has one argument but expects 0
func _complete(_animationName: String):
	# We've either completed the animation or the player has skipped
	emit_signal("intro_finished")
	queue_free()
