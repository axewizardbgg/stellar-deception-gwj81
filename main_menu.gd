extends Control

signal start_game

func _on_start_pressed() -> void:
	# Emit signal to start the game and destroy ourselves
	emit_signal("start_game")
	Snd.play("click")
	queue_free()


func _on_exit_pressed() -> void:
	# Exit the game
	get_tree().quit()
