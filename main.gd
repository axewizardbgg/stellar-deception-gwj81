extends Node2D

# Basically global game variables here
var destination: String = "01" # Corresponds to keys in the list in map_info.gd
var previous_destination: String = "00" # Not even sure if I'll need this tbh
var ship: int = 75
var crew: int = 75
var cash: int = 75
var player: RigidBody2D # Reference to the player ship once its been created
var hud: CanvasLayer # Reference to our HUD for updating UI
# Modifers that we need to add onto the ship whenever we create it
var bonus_thrust: float = 0
var bonus_hull: float = 0
var bonus_speed: float = 0
var bonus_weapons: Array = []
# Determines how many ships should attack the player
var danger: String = "Low" # "Low", "Medium", "High"
# Keep track of how many destinations we've arrived at. (Used for random things like determining asteroid count)
var level = 1

# Keep our music audio files preloaded
var music_space: AudioStream = load("res://audio/GWJ81_Space.mp3")
var music_location: AudioStream = load("res://audio/GWJ81_Location.mp3")

# Sometimes we need to re-engage enemies the player has run from
var event_spawner: Node2D
var previous_enemy: Dictionary = {
	"kind": "",
	"hull": -1.0
}

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Add ourselves to the main group so others can reference us easier
	add_to_group("main")
	
	# Connect the signal from our intro cutscene so we know when to show the menu
	$IntroCutscene.intro_finished.connect(_intro_complete)
	
	# Initialize our sound player autoload
	Snd.initialize(get_tree())

# Signal connector function for when the intro cutscene is finished
func _intro_complete():
	# IntroCutscene is done and will clean itself up, let's prepare the menu
	var menuScene: PackedScene = load("res://main_menu.tscn")
	var mainMenu: Control = menuScene.instantiate()
	# Add it to our UI viewport
	add_child(mainMenu)
	# Connect signal
	mainMenu.start_game.connect(_new_game)

# Signal connector function for when the player starts a new game
func _new_game():
	# Clear our scene of any lingering nodes
	_clear()
	
	# Add our audio player and have it start playing
	var snd_player: AudioStreamPlayer = AudioStreamPlayer.new()
	snd_player.stream = music_space
	snd_player.autoplay = true
	add_child(snd_player)
	
	# Main scene should be clear, let's re-initialize variables
	destination = "01" 
	previous_destination = "00"
	ship = 75
	crew = 75
	cash = 75
	bonus_thrust = 0
	bonus_hull = 0
	bonus_speed = 0
	bonus_weapons = []
	MapInfo.choices_remaining = MapInfo.choices.duplicate(true) # Reset our choices too.
	
	# Let's create our parallax background
	var para_bg: ParallaxBackground = load("res://parallax_background.tscn").instantiate()
	add_child(para_bg)
	
	# Let's create the location we're departing from
	var loc1: Node2D = load("res://location.tscn").instantiate()
	loc1.spr_path = MapInfo.list[previous_destination].spr_path
	loc1.destination = false
	add_child(loc1)
	
	# Now let's add our ship to the scene (no need to add modifiers since they're zero value)
	player = load("res://ship.tscn").instantiate()
	player.destination = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * randf_range(20000, 30000)
	add_child(player)
	# player.rotation = player.destination.angle()
	player.rotation = randf() * TAU # I changed my mind, face them in a random direction
	player.z_index = 1
	
	# Add our destination location
	var loc2: Node2D = load("res://location.tscn").instantiate()
	loc2.spr_path = MapInfo.list[destination].spr_path
	loc2.destination = true
	add_child(loc2)
	loc2.global_position = player.destination
	
	# Add our HUD UI
	hud = load("res://hud.tscn").instantiate()
	add_child(hud)
	hud.hull_pc = 100.0
	hud.ship_pc = 75.0
	hud.crew_pc = 75.0
	hud.cash_pc = 75.0
	hud.speed_pc = 0.0
	
	# Now that everything is created, connect some signals baby woo!
	player.hull_changed.connect(hud.update_hull)
	player.speed_changed.connect(hud.update_speed)
	player.dest_dir_changed.connect(hud.update_dest_dir)
	player.destination_reached.connect(_arrive)
	player.ship_destroyed.connect(_game_over)
	
	# Add in our event spawner
	event_spawner = load("res://event_spawner.tscn").instantiate()
	event_spawner.level = level
	add_child(event_spawner)
	event_spawner.show_event.connect(_show_event)
	
	# Oh yeah, also add our ASTEROID SPAWNER WOOOO
	var asteroid_spawner: Node2D = load("res://asteroid_spawner.tscn").instantiate()
	asteroid_spawner.player = player
	asteroid_spawner.max_asteroids = 6 + level
	add_child(asteroid_spawner)

# Clears the main scene of any children
func _clear() -> void:
	var children: Array = get_children()
	for child in children:
		if is_instance_valid(child):
			child.queue_free()

# Signal connection function for when the player arrives as their destination
func _arrive():
	# First let's clear the scene
	_clear()
	
	# Now, is this our final destination?
	if destination == "08":
		# It is! Display the ending cutscene
		_game_over("win")
	
	# Add our audio player and have it start playing
	var snd_player: AudioStreamPlayer = AudioStreamPlayer.new()
	snd_player.stream = music_location
	snd_player.autoplay = true
	add_child(snd_player)
	
	# Now let's set up our location UI
	var location_ui: Control = load("res://location_ui.tscn").instantiate()
	location_ui.location_data = {
		"title": MapInfo.list[destination].name,
		"desc": MapInfo.list[destination].description,
		"destinations": MapInfo.list[destination].destinations
	}
	location_ui.bar_values = {
		"ship": ship,
		"crew": crew,
		"cash": cash
	}
	
	# I should've made the root node of location UI a canvas layer, but whaterver
	var ui_layer: CanvasLayer = CanvasLayer.new()
	ui_layer.add_child(location_ui)
	# Add it to the scene and connect signals
	add_child(ui_layer)
	
	# Connect signals
	location_ui.bars_changed.connect(_bars_changed)
	location_ui.destination_selected.connect(_destination_selected)
	location_ui.other_effect.connect(_other_effect)

# Signal connector function for when a choice has been made.
func _chosen(choice: Dictionary):
	# Let's apply the effects first
	ship += choice.effect_ship
	crew += choice.effect_crew
	cash += choice.effect_cash
	
	# Ensure we don't exceed 100
	if ship > 100.0:
		ship = 100.0
	if crew > 100.0:
		crew = 100.0
	if cash > 100.0:
		cash = 100.0
	
	# Normal effects have been applied, are there any others?
	var effect_keys: Array = choice.other_effects.keys()
	for key in effect_keys:
		# What type of other effect do we have?
		match effect_keys[key]:
			"max_hull":
				bonus_hull += choice.other_effects[effect_keys[key]]
				

# Signal connector function for when the player makes a choice from the Location UI,
# or when something happens during travel
func _bars_changed(bars: Dictionary):
	# Update our variables
	ship = bars.ship
	crew = bars.crew
	cash = bars.cash
	
	# If our HUD is present, update that too
	if is_instance_valid(hud):
		hud.ship_pc = ship
		hud.crew_pc = crew
		hud.cash_pc = cash
	
	# Are any of the bars 0?
	if ship <= 0:
		_game_over("ship")
	if crew <= 0:
		_game_over("crew")
	if cash <= 0:
		_game_over("cash")

# Signal connector function for when the player selects their next destination
func _destination_selected(d_id: String):
	# Increase our level
	level += 1
	
	# Clear our scene of any lingering nodes
	_clear()
	
	# Add our audio player and have it start playing
	var snd_player: AudioStreamPlayer = AudioStreamPlayer.new()
	snd_player.stream = music_space
	snd_player.autoplay = true
	add_child(snd_player)
	
	# Main scene should be clear, let's update any variables that we need to
	previous_destination = destination
	destination = d_id 
	
	# Let's create our parallax background
	var para_bg: ParallaxBackground = load("res://parallax_background.tscn").instantiate()
	add_child(para_bg)
	
	# Let's create the location we're departing from
	var loc1: Node2D = load("res://location.tscn").instantiate()
	loc1.spr_path = MapInfo.list[previous_destination].spr_path
	loc1.destination = false
	add_child(loc1)
	
	# Determine where to create the destination location (default it to "Close" distance)
	var dest_loc: Vector2 = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * randf_range(30000, 35000)
	if MapInfo.list[destination].distance == "Average":
		dest_loc = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * randf_range(50000, 65000)
	if MapInfo.list[destination].distance == "Far":
		dest_loc = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * randf_range(70000, 95000)
	
	# Now let's prepare our player
	player = load("res://ship.tscn").instantiate()
	player.destination = dest_loc
	
	# Ensure we add modifiers
	player.thrust_power += bonus_thrust
	player.weapons += bonus_weapons
	player.max_hull += bonus_hull
	player.max_speed += bonus_speed
	
	# Add it to the scene and then set the rotation and z_index
	add_child(player)
	# player.rotation = player.destination.angle()
	player.rotation = randf() * TAU # I changed my mind, face them in a random direction
	player.z_index = 1
	
	# Add our destination location
	var loc2: Node2D = load("res://location.tscn").instantiate()
	loc2.spr_path = MapInfo.list[destination].spr_path
	loc2.destination = true
	add_child(loc2)
	loc2.global_position = player.destination
	
	# Add our HUD UI and initialize variables
	hud = load("res://hud.tscn").instantiate()
	add_child(hud)
	hud.hull_pc = 100.0
	hud.ship_pc = ship
	hud.crew_pc = crew
	hud.cash_pc = cash
	hud.speed_pc = 0.0
	
	# Now that everything is created, connect some signals baby woo!
	player.hull_changed.connect(hud.update_hull)
	player.speed_changed.connect(hud.update_speed)
	player.dest_dir_changed.connect(hud.update_dest_dir)
	player.destination_reached.connect(_arrive)
	player.ship_destroyed.connect(_game_over)
	
	# Add in our event spawner
	event_spawner = load("res://event_spawner.tscn").instantiate()
	event_spawner.level = level
	add_child(event_spawner)
	event_spawner.show_event.connect(_show_event)
	
	# Oh yeah, also add our ASTEROID SPAWNER WOOOO
	var asteroid_spawner: Node2D = load("res://asteroid_spawner.tscn").instantiate()
	asteroid_spawner.player = player
	asteroid_spawner.max_asteroids = 2 * level
	add_child(asteroid_spawner)

# Signal connector function for handling other effects from choices
func _other_effect(kind: String, value):
	# What kind of effect are we dealing with?
	match kind:
		"max_hull":
			bonus_hull += value
		"add_weapon":
			bonus_weapons.append(value)
		"thrust_power":
			bonus_thrust += value
		"teleport":
			if is_instance_valid(player):
				# Teleport the player 40k pixels away from the destination in a random direction
				player.global_position = player.destination + Vector2(40000, 0).rotated(deg_to_rad(randf_range(0,359)))
		"pirate_attack":
			# Spawn an enemy near the player
			_spawn_enemy("pirate")
		"alien_attack":
			# Spawn an enemy near the player
			_spawn_enemy("alien")
		"boss_attack":
			# SPAWN DA BAUWSS
			_spawn_enemy("boss")
		"repair":
			# Repair the player's hull if possible
			if is_instance_valid(player):
				player.current_hull += value
		"re-engage":
			# Reverse the player's direction and spawn enemy ship in front of player, facing away
			if is_instance_valid(player):
				player.linear_velocity = player.linear_velocity * -1 # Reverse direction
				player.rotation += PI # 180 degrees in radians
				_spawn_enemy(previous_enemy.kind, true)

# Helper function to spawn ships as needed
func _spawn_enemy(kind: String, face_away: bool = false) -> void:
	# First let's calculate where we need to position this ship (ahead of the player somewhere)
	var player_travel_dir: float = player.linear_velocity.angle()
	var spawn_pos: Vector2 = player.global_position + Vector2(1000 ,0).rotated(player_travel_dir + randf_range(-1,1))
	
	# Create the ship
	var enemy: RigidBody2D = load("res://enemy.tscn").instantiate()
	enemy.kind = kind
	enemy.player = player
	
	# Add it to our scene and set position and rotation
	add_child(enemy)
	enemy.global_position = spawn_pos
	enemy.rotation = (player.global_position - spawn_pos).angle()
	if face_away:
		enemy.rotation += PI
	
	# Connect signals
	enemy.lost.connect(_enemy_lost)
	enemy.enemy_destroyed.connect(_enemy_destroyed)

# Signal connector function for when the player outruns the enemy
func _enemy_lost(kind: String, hull: float):
	# Update our previous enemy dictionary
	previous_enemy.kind = kind
	previous_enemy.hull = hull
	
	# Have our event spawner spawn a special event
	event_spawner.spawn_special_event("enemy_lost")

# Signal connector function for when an enemy is destroyed
func _enemy_destroyed():
	# Have our event spawner spawn a special event
	event_spawner.spawn_special_event("enemy_destroyed")

# Signal connector function to show an event
func _show_event(event: Dictionary):
	# Prepare our event ui
	var event_ui: CanvasLayer = load("res://event_ui.tscn").instantiate()
	event_ui.bar_values = {
		"ship": ship,
		"crew": crew,
		"cash": cash
	}
	
	# Are we a special event?
	if !event.is_empty():
		# We are, set it
		event_ui.special_event = event
	
	# Connect the signals
	event_ui.bars_changed.connect(_bars_changed)
	event_ui.o_effect.connect(_other_effect)
	
	# Finally, add it to the scene, which will pause the game until it finishes
	add_child(event_ui)

func _game_over(cause: String):
	# Clear the scene and display the game over screen!
	_clear()
	var end_ui: Control = load("res://game_over.tscn").instantiate()
	end_ui.cause = cause
	# Once again I forgot to make the root node of the UI scene a canvas layer...
	var cv: CanvasLayer = CanvasLayer.new()
	cv.add_child(end_ui)
	add_child(cv)
	
	# Connect signal
	end_ui.go_to_menu.connect(_intro_complete)
