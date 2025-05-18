extends CanvasLayer

# Keep track of the various values we need to display ("pc" denotes a percentage)
var hull_pc: float = 0 : set = _set_hull_pc
var ship_pc: float = 0 : set = _set_ship_pc
var crew_pc: float = 0 : set = _set_crew_pc
var cash_pc: float = 0 : set = _set_cash_pc
var speed_pc: float = 0 : set = _set_speed_pc
var destination_direction: float = 0 : set = _set_dest_dir

# Setter functions
func _set_hull_pc(new_value: float) -> void:
	# Update our value and our progress bar
	hull_pc = new_value
	$UI/Hull.value = new_value
func _set_ship_pc(new_value: float) -> void:
	# Update our value and our progress bar
	ship_pc = new_value
	$UI/Ship.value = new_value
func _set_crew_pc(new_value: float) -> void:
	# Update our value and our progress bar
	crew_pc = new_value
	$UI/Crew.value = new_value
func _set_cash_pc(new_value: float) -> void:
	# Update our value and our progress bar
	cash_pc = new_value
	$UI/Cash.value = new_value
func _set_speed_pc(new_value: float) -> void:
	# Update our value and the needle rotation
	speed_pc = new_value
	$UI/SpeedNeedle.rotation = deg_to_rad(remap(new_value, 0.0, 100.0, -174.0, -41.0))
func _set_dest_dir(new_value: float) -> void:
	destination_direction = new_value
	$UI/DestinationNeedle.rotation = new_value
	
	# Last minute rushed change: This signal is basically being fired every frame, so
	# let's also update the distance to the destination as well (too lazy to make another signal)
	var player: RigidBody2D = get_tree().get_first_node_in_group("player")
	if is_instance_valid(player):
		var dist: float = (player.destination - player.global_position).length()
		# Ugly formatter code to make it work how I want
		var dist_str: String = str(roundf(dist))+" n"
		if dist >= 1000000:
			dist_str = str(snapped(dist / 1000000, 0.01))+"m n"
		if dist >= 1000:
			dist_str = str(snapped(dist / 1000, 0.01))+"k n"
		$UI/Distance.text = dist_str
		

# When the speed of the ship changes
func update_speed(new_value: float, max_value: float):
	# Update our label and our percentage variable (which will have its setter function update UI too)
	$UI/Label.text = str(int(roundf(new_value)))+"ns"
	speed_pc = (new_value / max_value) * 100

# When the hull integrity of the ship changes
func update_hull(new_value: float, max_value: float):
	# Update our percentage varaible (which will have its setter function update the UI)
	hull_pc = (new_value / max_value) * 100

# When the direction to the destination changes
func update_dest_dir(new_value: float):
	# Update our setter
	destination_direction = new_value
