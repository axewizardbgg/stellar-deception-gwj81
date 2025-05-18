extends Node2D

# Expected to be set before _ready
var player: RigidBody2D
var max_asteroids: int = 6


func _ready() -> void:
	# Create the specified amount of asteroids
	for i in max_asteroids:
		_create_asteroid()
	
func _create_asteroid():
	# Let's determine the player velocity (creating asteroids behind
		# the player while they're flying through space would be pretty pointless)
		var player_travel_dir: float = player.linear_velocity.angle()
		
		var spawn_pos: Vector2 = Vector2(randf_range(800, 999),0).rotated(player_travel_dir + randf_range(-0.5,0.5))
		spawn_pos += player.global_position
		
		# Create the asteroid and add it to our scene
		var asteroid: RigidBody2D = load("res://asteroid.tscn").instantiate()
		get_tree().get_first_node_in_group("main").add_child(asteroid)
		asteroid.global_position = spawn_pos
		
		# Connect the signal
		asteroid.asteroid_destroyed.connect(_asteroid_destroyed)

# Getting some wierd "Can't change this state while flushing queries" error, says to use call_deferred
func _asteroid_destroyed():
	if get_tree().get_node_count_in_group("asteroids") < max_asteroids:
		call_deferred("_create_asteroid")
