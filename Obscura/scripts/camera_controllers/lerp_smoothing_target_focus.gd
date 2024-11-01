class_name LerpSmoothingTargetFocus
extends CameraControllerBase

# Require exported
@export var lead_speed:float = 55.0
@export var catchup_delay_duration:float = 0.5
@export var catchup_speed:float = 45.0
@export var leash_distance:float = 50.0

# Internal variables
var cross_size: float = 5.0
var last_moving_time: float = 0.0
var lead_target_position: Vector3
var current_lead_offset: Vector3

func _ready() -> void:
	super()
	position = target.position
	lead_target_position = position
	current_lead_offset = Vector3.ZERO

func _process(delta: float) -> void:
	
	if !current:
		position = target.position
		return
	
	var target_pos = target.global_position
	var player_velocity = target.get_velocity()
	var player_speed = player_velocity.length()
	var is_moving = player_speed > 0.1
	var distance_to_target = global_position.distance_to(target_pos)
	
	if is_moving:
		var movement_direction = player_velocity.normalized()
		var min_lead_distance = leash_distance * 0.3
		var target_lead_distance = player_speed * 0.5
		
		if player_speed > target.BASE_SPEED:
			# Tbh don't know what to handle hyperspeed
			target_lead_distance = leash_distance * 1.35
		elif target_lead_distance < min_lead_distance:
			target_lead_distance = min_lead_distance
		
		var desired_lead_offset = movement_direction * target_lead_distance
		var lerp_speed = lead_speed * delta * (1.0 if distance_to_target > min_lead_distance else 2.0)
		
		current_lead_offset = current_lead_offset.lerp(desired_lead_offset, lerp_speed)
		lead_target_position = target_pos + current_lead_offset
		last_moving_time = 0.0
	else:
		last_moving_time += delta
		if last_moving_time >= catchup_delay_duration:
			current_lead_offset = current_lead_offset.lerp(Vector3.ZERO, catchup_speed * delta * 0.1)
			lead_target_position = target_pos + current_lead_offset
	
	var camera_lerp_speed = delta * (10.0 if distance_to_target < 1.0 else 5.0)
	global_position = global_position.lerp(lead_target_position, camera_lerp_speed)
	
	if distance_to_target > leash_distance:
		var direction_to_target = (target_pos - global_position).normalized()
		global_position = target_pos - direction_to_target * leash_distance
	
	if draw_camera_logic:
		draw_logic()
	
	super(delta)

# Function to draw a cross at the center of the screen.
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Top.
	immediate_mesh.surface_add_vertex(Vector3(global_position.x, 0, global_position.z + cross_size / 2))
	# Bottom.
	immediate_mesh.surface_add_vertex(Vector3(global_position.x, 0, global_position.z - cross_size / 2))
	
	# Left.
	immediate_mesh.surface_add_vertex(Vector3(global_position.x - cross_size / 2, 0, global_position.z))
	# Right.
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + cross_size / 2, 0, global_position.z))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	
	# If i dont comment out this line, the cross just floating around.
	#mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#print("cams:", global_position)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
