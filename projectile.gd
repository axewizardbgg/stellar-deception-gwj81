extends Node2D

# Expected to be set before _ready
var player_fired: bool = false # Determines who this projectile should collide with
var spr_path: String = "res://sprites/GWJ81_Projectile1_b.png"
var velocity: Vector2 # Used to move every frame
var damage: float = 3
var duration: float = 1 # seconds

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Load our sprite
	$Sprite2D.texture = load(spr_path)
	
	# Set our timer duration and connect function for when it times out
	$Timer.wait_time = duration
	$Timer.timeout.connect(func (): self.queue_free())
	

# Called every frame, delta is the time elapsed since last frame
func _process(delta: float) -> void:
	# Translate our position based on our velocity
	translate(velocity * delta)

# Signal connector function for when we collide with something
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Is the colliding body a valid instance?
	if !is_instance_valid(body):
		# No, do nothing
		return
	
	# Are we colliding with an Asteroid?
	if body.is_in_group("asteroids"):
		# We are, call their take_damage and destroy ourselves
		body.take_damage(damage)
		_create_splodey()
		queue_free()
		return
	
	# Who are we meant to collide with?
	if player_fired:
		# We're meant to collide with enemies, are we colliding with one?
		if body.is_in_group("enemies"):
			# They are, call their take_damage and destroy ourselves
			body.take_damage(damage)
			_create_splodey()
			queue_free()
			return
	elif body.is_in_group("player"):
		# We're meant to collide with the player
		body.take_damage(damage)
		_create_splodey()
		queue_free()
		return

# Create EXPLOSIONS (splodeys lol)
func _create_splodey():
	var splodey: Node2D = load("res://splodey.tscn").instantiate()
	get_tree().get_first_node_in_group("main").add_child(splodey)
	splodey.global_position = global_position
	Snd.play("splodey")
