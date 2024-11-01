class_name SpeedupPushZoneCamera
extends CameraControllerBase

@export var push_ratio: float = 0.6
@export var pushbox_top_left: Vector2 = Vector2(-10, 10)
@export var pushbox_bottom_right: Vector2 = Vector2(10, -10)
@export var speedup_zone_top_left: Vector2 = Vector2(-5, 5)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5, -5)

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	
	if !current:
		position = target.position
		return
		
	if draw_camera_logic:
		draw_logic()
	
	var target_pos = target.global_position
	var player_velocity = target.get_velocity()
	# Check if target is in speedup zone or pushbox.
	var in_speedup = check_speedup_boundaries()
	var in_pushbox = check_pushbox_boundaries()
	var touching_edges = get_touched_edges()
	var is_moving = player_velocity.length() > 0.1
	var player_direction = player_velocity.normalized()
	var move_distance = Vector3(
		player_velocity.x * (1 if touching_edges.x else push_ratio) * delta,
		player_velocity.y * delta,
		player_velocity.z * (1 if touching_edges.y else push_ratio) * delta
	)
	
	# It sometimes still went over the border, I can only use this to handle hyperspeed.
	if player_velocity.length() == target.HYPER_SPEED:
		global_position = target_pos
	
	# Using if in_pushbox to replace clamping.
	if !in_pushbox:
		global_position = target_pos
	
	if is_moving:
		if in_pushbox and !in_speedup:
			#print("enter")
			global_position += move_distance 
		if in_speedup:
			return
			
	#clamp_camera_within_pushbox()		
	super(delta)

#func clamp_camera_within_pushbox() -> void:
	#print("clamping")
	#var tpos = target.global_position
	#global_position.x = clamp(global_position.x, pushbox_top_left.x + global_position.x, pushbox_bottom_right.x + global_position.x)
	#global_position.z = clamp(global_position.z, pushbox_bottom_right.y + global_position.z, pushbox_top_left.y + global_position.z)
	
# Returns which edges are being touched (x for left/right, y for top/bottom)
func get_touched_edges() -> Vector2:
	var tpos = target.global_position
	var touching = Vector2.ZERO
	
	# For debugging, will comment out after it function.
	#print("Left check:", tpos.x - target.WIDTH / 2.0, " vs ", global_position.x + pushbox_top_left.x)
	#print("Right check:", tpos.x + target.WIDTH / 2.0, " vs ", global_position.x + pushbox_bottom_right.x)
	#print("Top check:", tpos.z + target.HEIGHT / 2.0, " vs ", global_position.z + pushbox_top_left.y)
	#print("Bottom check:", tpos.z - target.HEIGHT / 2.0, " vs ", global_position.z + pushbox_bottom_right.y)
	
	# Check X edges (left/right)
	if abs((tpos.x - target.WIDTH / 2.0) - (global_position.x + pushbox_top_left.x)) <= 0.25:
		touching.x = 1.0  
		#print("Touching left!")
	elif abs((tpos.x + target.WIDTH / 2.0) - (global_position.x + pushbox_bottom_right.x)) <= 0.25:
		touching.x = 1.0  
		#print("Touching right!")

	# Check Z edges (top/bottom)
	# For the print statement, idk why it printed the opposite way even tho seems condition check is correct...
	if abs((tpos.z + target.HEIGHT / 2.0) - (global_position.z + pushbox_top_left.y)) <= 0.25:
		touching.y = 1.0 
		#print("Touching bottom!")
	elif abs((tpos.z - target.HEIGHT / 2.0) - (global_position.z + pushbox_bottom_right.y)) <= 0.25:
		touching.y = 1.0 
		#print("Touching top!")
		
	if touching.x == 1.0 and touching.y == 1.0:
		print("TOUCHING BOTH!")
	return touching


func check_speedup_boundaries() -> bool:
	var tpos = target.global_position
	# Boundary checks.
	if (tpos.x - target.WIDTH / 2.0 > global_position.x + speedup_zone_top_left.x and 
		tpos.x + target.WIDTH / 2.0 < global_position.x + speedup_zone_bottom_right.x and 
		tpos.z + target.HEIGHT / 2.0 < global_position.z + speedup_zone_top_left.y and
		tpos.z - target.HEIGHT / 2.0 > global_position.z + speedup_zone_bottom_right.y):
		return true
	return false
			
func check_pushbox_boundaries() -> bool:
	var tpos = target.global_position
	# Boundary checks.
	if (tpos.x - target.WIDTH / 2.0 > global_position.x + pushbox_top_left.x and 
		tpos.x + target.WIDTH / 2.0 < global_position.x + pushbox_bottom_right.x and
		tpos.z + target.HEIGHT / 2.0 < global_position.z + pushbox_top_left.y and
		tpos.z - target.HEIGHT / 2.0 > global_position.z + pushbox_bottom_right.y):
		return true
	return false	

func draw_logic() -> void:
	var t_pos = target.global_position
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)  
	# Draw pushbox.
	var pushbox_top_left_corner = Vector3(global_position.x + pushbox_top_left.x, t_pos.y,  global_position.z + pushbox_top_left.y)
	var pushbox_top_right_corner = Vector3(global_position.x + pushbox_bottom_right.x, t_pos.y, global_position.z + pushbox_top_left.y)
	var pushbox_bottom_right_corner = Vector3(global_position.x + pushbox_bottom_right.x, t_pos.y, global_position.z + pushbox_bottom_right.y)
	var pushbox_bottom_left_corner = Vector3(global_position.x + pushbox_top_left.x, t_pos.y, global_position.z + pushbox_bottom_right.y)
	
	immediate_mesh.surface_add_vertex(pushbox_top_right_corner)
	immediate_mesh.surface_add_vertex(pushbox_bottom_right_corner)
	
	immediate_mesh.surface_add_vertex(pushbox_bottom_right_corner)
	immediate_mesh.surface_add_vertex(pushbox_bottom_left_corner)
	
	immediate_mesh.surface_add_vertex(pushbox_top_left_corner)
	immediate_mesh.surface_add_vertex(pushbox_bottom_left_corner)
	
	immediate_mesh.surface_add_vertex(pushbox_top_right_corner)
	immediate_mesh.surface_add_vertex(pushbox_top_left_corner)
	
	# Draw Speedup Zone.
	var speedup_zone_top_left_corner = Vector3(global_position.x + speedup_zone_top_left.x, t_pos.y, global_position.z + speedup_zone_top_left.y)
	var speedup_zone_top_right_corner = Vector3(global_position.x + speedup_zone_bottom_right.x, t_pos.y, global_position.z + speedup_zone_top_left.y)
	var speedup_zone_bottom_right_corner = Vector3(global_position.x + speedup_zone_bottom_right.x, t_pos.y, global_position.z + speedup_zone_bottom_right.y)
	var speedup_zone_bottom_left_corner = Vector3(global_position.x + speedup_zone_top_left.x, t_pos.y, global_position.z + speedup_zone_bottom_right.y)
	
	immediate_mesh.surface_add_vertex(speedup_zone_top_right_corner)
	immediate_mesh.surface_add_vertex(speedup_zone_bottom_right_corner)
	
	immediate_mesh.surface_add_vertex(speedup_zone_bottom_right_corner)
	immediate_mesh.surface_add_vertex(speedup_zone_bottom_left_corner)
	
	immediate_mesh.surface_add_vertex(speedup_zone_top_left_corner)
	immediate_mesh.surface_add_vertex(speedup_zone_bottom_left_corner)
	
	immediate_mesh.surface_add_vertex(speedup_zone_top_right_corner)
	immediate_mesh.surface_add_vertex(speedup_zone_top_left_corner)
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	#mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
