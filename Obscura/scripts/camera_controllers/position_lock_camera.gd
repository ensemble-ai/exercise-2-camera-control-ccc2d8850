class_name PositionLockCamera
extends CameraControllerBase

# 5 by 5 unit cross
@export var cross_size = 5.0 

func _ready() -> void:
	super()
	position = target.position
	
# Called every frame
func _process(delta: float) -> void:
	
	if !current:
		position = target.position
		return
		
	if draw_camera_logic:
		draw_cross()
	
	# Rotate the angle to make it not weird.
	# rotation_degrees = Vector3(270, 0, 0)
	global_position = target.global_position
	super(delta)

# Function to draw a cross at the center of the screen.
func draw_cross() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Top.
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_size))
	# Bottom.
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_size))
	
	# Left.
	immediate_mesh.surface_add_vertex(Vector3(-cross_size, 0, 0))
	# Right.
	immediate_mesh.surface_add_vertex(Vector3(cross_size, 0, 0))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
