class_name HorizontalAutoScroll
extends CameraControllerBase

# required
@export var top_left: Vector2 = Vector2(-5,5)
@export var bottom_right: Vector2 = Vector2(5,-5)
@export var autoscroll_speed: Vector3 = Vector3(10, 0, 0)


func _ready() -> void:
	super()
	position = target.position
	
# Called every frame.
func _process(delta: float) -> void:
	
	if !current:
		position = target.position
		return
		
	if draw_camera_logic:
		draw_logic()
		
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta
	
	check_boundaries()
	super(delta)
	#rotation_degrees = Vector3(270, 0, 0)
	
func check_boundaries() -> void:
	var tpos = target.global_position
	
	# Boundary checks.
	if tpos.x - target.WIDTH / 2.0 < global_position.x + top_left.x:
		#print("left")
		target.global_position.x = global_position.x + top_left.x + target.WIDTH / 2.0
	if tpos.x + target.WIDTH / 2.0 > global_position.x + bottom_right.x:
		#print("right")
		target.global_position.x = global_position.x + bottom_right.x - target.WIDTH / 2.0
	if tpos.z + target.HEIGHT / 2.0 > global_position.z + top_left.y:
		#print("bottom")
		target.global_position.z = global_position.z + top_left.y - target.HEIGHT / 2.0
	if tpos.z - target.HEIGHT / 2.0 < global_position.z + bottom_right.y:
		#print("top")
		target.global_position.z = global_position.z + bottom_right.y + target.HEIGHT / 2.0
	

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Define the box edges based on top_left and bottom_right
	var top_left_corner = Vector3(top_left.x, 0, top_left.y)
	var top_right_corner = Vector3(bottom_right.x, 0, top_left.y)
	var bottom_right_corner = Vector3(bottom_right.x, 0, bottom_right.y)
	var bottom_left_corner = Vector3(top_left.x, 0, bottom_right.y)
	
	immediate_mesh.surface_add_vertex(top_right_corner)
	immediate_mesh.surface_add_vertex(bottom_right_corner)
	
	immediate_mesh.surface_add_vertex(bottom_right_corner)
	immediate_mesh.surface_add_vertex(bottom_left_corner)
	
	immediate_mesh.surface_add_vertex(top_left_corner)
	immediate_mesh.surface_add_vertex(bottom_left_corner)
	
	immediate_mesh.surface_add_vertex(top_right_corner)
	immediate_mesh.surface_add_vertex(top_left_corner)

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
