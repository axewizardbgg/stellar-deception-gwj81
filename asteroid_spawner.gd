extends Node2D

# Expected to be set before _ready
var player: RigidBody2D
var max_asteroids: int = 2

# Other asteroidy stuff
var asteroids: Array = []
var max_distance: float = 1000

func _ready() -> void:
	# Connect our timer's timeout signal
	$Timer.timeout.connect(_handle_asteroids)

func _handle_asteroids():
	# Do we have a player?
	if !is_instance_valid(player):
		# No, do nothing
		return
	
	# We have a player, let's check our existing asteroids and see if they're within
	# a relevant distance of the player
	var to_be_deleted: Array # Never mutate an array while you're iterating through it, bad things can happen!
	for i in asteroids.size():
		# Is this asteroid valid?
		if !is_instance_valid(asteroids[i]):
			# No, skip to next iteration
			continue
		
		# Our Asteroid is still valid, but is it within range?
		var dist: float = (player.global_position - asteroids[i].global_position).length()
		if dist > max_distance:
			# No it is not within range, mark it for deletion
			to_be_deleted.append(i)
	
	# Do we have any asteroids marked for deletion?
	to_be_deleted.reverse() # Reverse the order, so we don't get out of bounds errors
	for idx in to_be_deleted:
		asteroids[idx].queue_free()
		asteroids.remove_at(idx)
	
	# Asteroids have been deleted. Do we need to create any more?
	if asteroids.size() >= max_asteroids:
		# Nope, nothing else to do here
		return
	
	# We do need to create more, let's determine the player velocity (creating asteroids behind
	# the player while they're flying through space would be pretty pointless)
	var player_travel_dir: float = player.linear_velocity.angle()
	
	# Create as many asteroids as we need to reach the max count
	for i in (max_asteroids - asteroids.size()):
		# Let's determine where to create it
		var spawn_pos: Vector2 = Vector2(randf_range(800, 999),0).rotated(player_travel_dir + randf_range(-0.5,0.5))
		spawn_pos += player.global_position
		
		# Create the asteroid and add it to our scene
		var asteroid: RigidBody2D = load("res://asteroid.tscn").instantiate()
		get_tree().get_first_node_in_group("main").add_child(asteroid)
		asteroid.global_position = spawn_pos
		
		# Also add it to our array
		asteroids.append(asteroid)
