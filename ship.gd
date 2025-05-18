extends RigidBody2D

# Define some signals that we'll emit for various scenarios
signal hull_changed(new_value, max_value) # Used by our UI
signal speed_changed(new_value, max_value) # Used by UI
signal dest_dir_changed(new_value) # Used by UI
signal ship_destroyed # Used by our Main script to know when to show game over screen
signal destination_reached # Used by our Main script

# Ship Properties
var thrust_power: float = 150.0 # The rate at which we accelerate
var torque_power: float = 10000.0 # The amount of torque we apply to rotate our ship
var max_speed: float = 600.0 # Maximum rate of travel
var max_hull: float = 100.0 # Maximum health of our ship
var current_hull: float
var current_speed: float
var destination: Vector2 # Global position, set before _ready by the calling instance
var weapons: Array = [
	"heavy_cannon",
	"light_cannon"
]
var weapon_nodes: Array = [] # Will be set in _ready
var is_disabled: bool = false # Some enemies might briefly disable us

# Called when the node enters the scene tree for the first time
func _ready():
	# Whenever the ship is created, let's just give it full health/hull
	current_hull = max_hull
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	$Area2D.area_entered.connect(_on_area_entered)
	
	# Add to the player group (even though we're the only one, it's easier to tell if we're the player)
	add_to_group("player")
	
	# Initialize our weapons
	setup_weapons()

# Called during the processing step of the main loop. Processing happens at every frame and as fast 
# as possible, so the delta time since the previous frame is not constant. delta is in seconds.
func _process(delta: float):
	# Handle weapon firing
	if Input.is_action_pressed("attack") and !is_disabled:
		_fire_weapons()
	
	# Our direction to our destination is probably always changing, emit signal
	emit_signal("dest_dir_changed", (destination-global_position).angle())

# Called during physics processing, allowing you to read and safely modify the simulation state 
# for the object. By default, it is called before the standard force integration, but the 
# custom_integrator property allows you to disable the standard force integration and do fully 
# custom force integration for a body.
func _integrate_forces(state: PhysicsDirectBodyState2D):
	# Get input direction (This should work for both keyboard and controllers woo!)
	var thrust_direction: float = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var rotation_direction: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# If our thrust direction is negative, that means we want to go backwards, but I don't think
	# it should do that at the same rate, so maybe 1/5th of the normal forward speed
	if thrust_direction < 0:
		thrust_direction = thrust_direction/5
	
	# Rotate the ship by applying Torque
	apply_torque(rotation_direction * torque_power)
	
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
		emit_signal("speed_changed", current_speed, max_speed)

# Setup weapons
func setup_weapons() -> void:
	# Clear any weapon nodes we have
	for weapon in $Weapons.get_children():
		weapon.queue_free()
	
	# Recreate our weapon nodes from our weapons list
	for entry in weapons:
		var weapon: Node2D = load("res://weapon.tscn").instantiate()
		weapon.kind = entry
		weapon.player_fired = true
		weapon.ship = self
		weapon_nodes.append(weapon)
		$Weapons.add_child(weapon)

# GIVE EM A BROADSIDE BOYS
func _fire_weapons() -> void:
	# Tell each of our weapons to fire
	for weapon in weapon_nodes:
		weapon.fire()

# What happens when we take damage
func take_damage(damage: float):
	# Take the damage and emit signal that our current hull has changed
	current_hull -= damage
	emit_signal("hull_changed", current_hull, max_hull)
	
	# Did we die?
	if current_hull <= 0:
		# Oh noes, we dead!
		emit_signal("ship_destroyed", "hull")

# Signal connector function for when we collide with another physics body (like an asteroid!)
func _on_body_entered(body: Node):
	# Are we colliding with an Asteroid or another Ship?
	if !(body.is_in_group("asteroids") || body.is_in_group("enemies")):
		# No, nothing to do here
		return
	
	# We're colliding with an Asteroid, determine how much damage we take!
	# We'll get the relative velocity and then scale the damage based on that
	var relative_velocity: Vector2 = linear_velocity - body.linear_velocity
	var damage: float = relative_velocity.length() * 0.01 # Let's say only 1% of that as damage
	
	# Did we even take enough damage to care?
	if damage < 1:
		# No, forget it
		return
	
	# Ok we have some damage, now we gotta TAKE IT
	take_damage(damage)
	
	# Play the crash sound
	Snd.play("crash")

# Signal connector function for when we collide with an area2d (such as a location)
func _on_area_entered(area: Area2D):
	# Are we colliding with our destination?
	if area.owner.is_in_group("destination"):
		# We are! Emit signal that we've reached our destination
		emit_signal("destination_reached")
