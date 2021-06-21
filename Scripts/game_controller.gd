extends Spatial

var angle = 0.0;
onready var chars = [
	get_node("Player"),
	get_node("PlayerMonster")
];
onready var active_char = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# character switching
	if Input.is_action_just_pressed("party_select"):
		active_char = (active_char + 1) % len(chars);
	
	# movement
	var move_target = Vector2(0,0);
	var move_magnitude = Vector2(0,0);
	if Input.is_action_pressed("game_up"):
		move_target.y -= 1;
		move_magnitude.y = Input.get_action_strength("game_up");
	if Input.is_action_pressed("game_down"):
		move_target.y += 1;
		move_magnitude.y = Input.get_action_strength("game_down");
	if Input.is_action_pressed("game_left"):
		move_target.x -= 1;
		move_magnitude.x = Input.get_action_strength("game_left");
	if Input.is_action_pressed("game_right"):
		move_target.x += 1;
		move_magnitude.x = Input.get_action_strength("game_right");
	
	var move_target_normalized = move_target.normalized()
	move_target_normalized *= move_magnitude;
	
	# move currently controlled character
	chars[active_char].translate(Vector3(
		(cos(angle) * move_target_normalized.x + sin(angle) * move_target_normalized.y) * 10 * delta,
		0,
		(cos(angle) * move_target_normalized.y + sin(angle) * move_target_normalized.x) * 10 * delta	
	));
	
	# target camera to currently controlled character
	var camera_target = Vector3(
		chars[active_char].transform.origin.x + sin(angle) * 14,
		8,
		chars[active_char].transform.origin.z + cos(angle) * 14
	);
	
	$Camera.transform.origin = lerp($Camera.transform.origin, camera_target, 0.25);
