extends RigidBody2D

# Asteroidy stuff
var size: float = 1.0 # How big is our asteroid? (usually 0.3 to 1.0 is the range here)
var health: float = 15.0 # How much damage can the asteroid take before breaking
var min_speed: float = 10.0 # For randomizing speed
var max_speed: float = 250.0


# Called when the node enters the scene tree for the first time
func _ready():
	# Determine which sprite and collision shape to use
	var num: int = randi() % 5 + 1
	
	# Set the sprite and collission shape to be visible (and remove the others)
	for child in get_children():
		# Are we one of the nodes we care about?
		if child.name != "Spr"+str(num) && child.name != "Col"+str(num):
			# Not one we care about, remove it and skip to next iteration
			child.queue_free()
			continue
		
		# This is one we want to keep, set it to be visible
		child.visible = true
	
	# Add it to the Asteroids group for easier collision detection by the ships
	add_to_group("asteroids")
	
	# Randomize the scale and the rotation
	scale = Vector2.ONE * (size + randf_range(-0.7, -0.3)) # 0.2 skew from -0.5
	rotation = randf() * TAU
	
	# Set it's initial velocity to a random speed and direction
	var direction: Vector2 = Vector2(randf_range(-1, 1),randf_range(-1, 1)).normalized()
	var speed: float = randf_range(min_speed, max_speed)
	linear_velocity = direction * speed # Scale our direction vector by our speed.
	
	# Let's also have it spin in a random direction as well
	angular_velocity = randf_range(-3.5, 3.5)

# When ships shoot us or collide with us, we can take damage
func take_damage(amount: float):
	# Take the damage
	health -= amount * 3 # TRIPLE DAMAGE BABY
	# Do we need to break apart?
	if health <= 0:
		# Yup, breaketh thyself fool! (Emit signal that we've been destroyed)
		queue_free()
