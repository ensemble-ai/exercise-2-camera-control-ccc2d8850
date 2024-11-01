class_name PositionLockLerpSmoothing 
extends CameraControllerBase

# require exported
@export var follow_speed:float = 40.0
@export var catchup_speed:float = 45.0
@export var leash_distance:float = 50.0
var cross_size = 5.0

func _ready() -> void:
	super()
	global_position = target.global_position
	
# Called every frame
func _process(delta: float) -> void:
	
	if !current:
		return
		
	# Check if players moving
	var player_velocity = target.get_velocity()
	var player_moving = player_velocity.length() > 0.1
	var target_pos = target.global_position
	var direction_to_target = (target_pos - global_position).normalized()
	var distance_to_target = global_position.distance_to(target_pos)
	
	# condition between two speeds
	var move_speed = follow_speed if player_moving else catchup_speed
	
	#print("t:", target_pos)
	#print("g:", global_position)
	
	# skip this frame if target at camera position
	if distance_to_target < 0.01:
		return
	
	# update the global position without using lerp
	var move_distance = min(move_speed * delta, distance_to_target)
	if move_distance > 0:
		global_position += direction_to_target * move_distance
	
	# Constrain distance to within leash_distance
	if distance_to_target > leash_distance:
		# if exceed leash, teleport ><
		global_position += direction_to_target * leash_distance
	
	if draw_camera_logic:
		draw_logic()
	
	super(delta)

# Function to draw a cross at the center of the screen
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
