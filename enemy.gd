extends RigidBody2D

signal lost(kind: String, hull: float)
signal enemy_destroyed

# Expected to be set before _ready
var kind: String = "pirate" # also "alien" and "boss"
var player: RigidBody2D # Our enemy!

# Ship Stuff
var thrust_power: float = 130.0 # The rate at which we accelerate
var torque_power: float = 10000.0 # The amount of torque we apply to rotate our ship
var max_speed: float = 400.0 # Maximum rate of travel
var max_hull: float = 60.0 # Maximum health of our ship
var current_hull: float
var current_speed: float
var weapons: Array = [
	"heavy_cannon",
]
var weapon_nodes: Array = [] # Will be set in _ready



# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# First let's determine which ship we are
	var spr_num: int = 1
	match kind:
		"pirate":
			# 1 and 2 are for pirates, let's pick one
			spr_num = randi() % 2 + 1
		"alien":
			# Alien is #3
			spr_num = 3
			weapons.append("heavy_cannon")
			max_hull = 85
		"boss":
			# Boss is #4
			spr_num = 4
			weapons.append("heavy_cannon")
			weapons.append("heavy_cannon")
			weapons.append("heavy_cannon")
			max_speed = 300
			max_hull = 200
	
	# Set the sprite and collission shape to be visible (and remove the others)
	for child in get_children():
		# Are we one of the nodes we care about?
		if child.name != "Spr"+str(spr_num) && child.name != "Col"+str(spr_num):
			# Not one we care about, remove it and skip to next iteration
			child.queue_free()
			continue
		
		# This is one we want to keep, set it to be visible
		child.visible = true
	
	# Add ourselves to the enemies group
	add_to_group("enemies")
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	
	# Setup our weapons
	_setup_weapons()
	
	# Set our health
	current_hull = max_hull
	
	# Play the alarm sound
	Snd.play("alert")

# Called during the processing step of the main loop. Processing happens at every frame and as fast 
# as possible, so the delta time since the previous frame is not constant. delta is in seconds.
func _process(delta: float):
	# Get positional deets
	var diff: Vector2 = player.global_position - global_position
	
	# Are we close enough to fire?
	if diff.length() < 700:
		# Close enough, fire!
		_fire_weapons()
	
	# Are we too far away? Has the player outrun us?
	if diff.length() > 3000:
		# Yes, emit signal and destroy ourselves
		emit_signal("lost", kind, current_hull)
		queue_free()

# Called during physics processing, allowing you to read and safely modify the simulation state 
# for the object. By default, it is called before the standard force integration, but the 
# custom_integrator property allows you to disable the standard force integration and do fully 
# custom force integration for a body.
func _integrate_forces(state: PhysicsDirectBodyState2D):
	# Get input direction
	var thrust_direction: float = 1 # Always accelerating
	
	# Calculate the shortest angle difference
	var angle_diff = wrapf((player.global_position - global_position).angle() - rotation, -PI, PI)
	
	# Apply torque based on the angle difference
	var torque_amount = angle_diff * torque_power
	apply_torque(torque_amount)
	
	# Apply thrust in the direction the ship is facing
	if thrust_direction != 0:
		var thrust_vector = Vector2(thrust_direction * thrust_power, 0).rotated(rotation)
		apply_central_force(thrust_vector)
	
	# Ensure we do not exceed our max speed
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	
	# Update our current speed and emit signal if needed
	if linear_velocity.length() != current_speed:
		current_speed = linear_velocity.length()

# Signal connector function for when we collide with another physics body (like an asteroid!)
func _on_body_entered(body: Node):
	# Are we colliding with an Asteroid or another Ship?
	if !(body.is_in_group("asteroids") || body.is_in_group("enemies")):
		# No, nothing to do here
		return
	
	# We're colliding with an Asteroid, determine how much damage we take!
	# We'll get the relative velocity and then scale the damage based on that
	var relative_velocity: Vector2 = linear_velocity - body.linear_velocity
	var damage: float = relative_velocity.length() * 0.05 # Let's say only 5% of that as damage
	
	# Did we even take enough damage to care?
	if damage < 1:
		# No, forget it
		return
	
	# Ok we have some damage, now we gotta TAKE IT
	take_damage(damage)
	
	# Play the crash sound
	Snd.play("crash")

# What happens when we take damage
func take_damage(damage: float):
	# Take the damage
	current_hull -= damage
	
	# Did we die?
	if current_hull <= 0:
		# Oh noes, we dead!
		emit_signal("enemy_destroyed")
		queue_free()

# Setup weapons
func _setup_weapons() -> void:
	# Recreate our weapon nodes from our weapons list
	for entry in weapons:
		var weapon: Node2D = load("res://weapon.tscn").instantiate()
		weapon.kind = entry
		weapon.player_fired = false
		weapon.ship = self
		weapon_nodes.append(weapon)
		add_child(weapon)

# GIVE EM A BROADSIDE BOYS
func _fire_weapons() -> void:
	# Tell each of our weapons to fire
	for weapon in weapon_nodes:
		weapon.fire()
