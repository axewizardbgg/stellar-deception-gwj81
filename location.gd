extends Node2D

# These are expected to be set before the node enters the scene tree (before _ready)
var spr_path: String
var destination: bool = false # Determines if we're departing from this location, or going to it.

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Load the sprite
	$Sprite2D.texture = load(spr_path)
	
	# Adjust our collision shape to the relative size of the sprite
	#var spr_size: Vector2 = $Sprite2D.texture.get_size()
	#var smallest_dimension: float = spr_size.x
	#if spr_size.y < smallest_dimension:
		#smallest_dimension = spr_size.y
	#$Area2D/CollisionShape2D.shape.radius = smallest_dimension / 2
	
	# Are we departing from this location?
	if destination:
		# No, this location is our destination, add it to group and stop execution
		add_to_group("destination")
		scale = Vector2(0.3, 0.3) # Make it small, and it will get larger as we get closer
		return
	
	# We are departing from this location, so we'll tween our scale down until we disappear
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 2).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): self.queue_free())

# Called every frame
func _process(delta: float) -> void:
	# Are we the destination?
	if !destination:
		# No, do nothing
		return
	
	# How far away is the player?
	var player: RigidBody2D = get_tree().get_first_node_in_group("player")
	var dist: float = (player.global_position - global_position).length()
	
	# Is the player within range that we should be scaling up?
	if dist < 500:
		# Yes, scale it up!
		var s: float = scale.x
		s = remap(dist, 500, 100, 0.3, 1)
		scale = Vector2(s,s)
