extends Node2D

# Expected to be set before _ready()
var kind: String = "light_cannon" # "light_cannon" (turreted) and "heavy_cannon" (fixed)
var player_fired: bool = false # Determines who can take damage from this.
var ship: Node2D # The ship that we're a weapon of

# Initalize these as if they are a light cannon (if heavy they will be set in _ready)
var damage: float = 3
var projectile_speed: float = 1200 # pixels per second
var projectile_duration: float = 1 # seconds
var armed: bool = true
var projectile_spr_path: String = "res://sprites/GWJ81_Projectile1_b.png"

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# What type of weapon are we?
	if kind == "heavy_cannon":
		# Initialize our variables (we already set light_cannon's earlier)
		damage = 8
		projectile_speed = 1000
		projectile_duration = 2
		projectile_spr_path = "res://sprites/GWJ81_Projectile2_b.png"
		# Update the interval of our timer
		$Timer.wait_time = 0.8
	
	# Connect timer's timeout signal
	$Timer.timeout.connect(func (): armed = true)

# FIRE!
func fire() -> void:
	# Are we able to fire right now?
	if !armed:
		# No, nothing to do yet
		return
	
	# We're ready to fire, create a projectile and populate basic variables
	var projectile: Node2D = load("res://projectile.tscn").instantiate()
	projectile.player_fired = player_fired
	projectile.damage = damage
	projectile.duration = projectile_duration
	projectile.spr_path = projectile_spr_path
	
	# Where are we aiming?
	var aim_direction: float
	if kind == "light_cannon":
		# We're a turret, aim towards mouse position
		aim_direction = (get_global_mouse_position() - global_position).angle()
	else:
		# We're a fixed weapon, aim in same direction ship is facing
		aim_direction = ship.rotation
		
	# Determine projectile velocity (taking into account ship velocity as well)
	var aim_velocity: Vector2 = Vector2(projectile_speed, 0).rotated(aim_direction)
	projectile.velocity = aim_velocity + ship.linear_velocity
	
	# Determine position offset
	var pos_offset: Vector2 = Vector2(randf_range(-20, 20), randf_range(-20, 20))
	
	# Add projectile to our main scene
	get_tree().get_first_node_in_group("main").add_child(projectile)
	projectile.global_position = global_position + pos_offset
	projectile.rotation = aim_direction
	
	# Play the sound
	Snd.play(kind)
	
	# We've fired, start our timer again
	armed = false
	$Timer.start()
