extends Node

@export var cameras:Array[CameraControllerBase]

var current_controller:int = 0


func _ready():
	for camera in cameras:
		if null != camera:
			camera.current = false
	if(len(cameras) > current_controller+1):
		cameras[current_controller].make_current()


func _process(_delta):
	#　Thank you Dillon Mannion from discord answered my question why draw_logic always become false while switching camer even tho its true by default. 
	if Input.is_action_just_pressed("cycle_camera_controller"):
		if cameras[current_controller] != null:
			cameras[current_controller].current = false
			cameras[current_controller].draw_camera_logic = false

		current_controller = (current_controller + 1) % len(cameras)

		if cameras[current_controller] != null:
			cameras[current_controller].make_current()
			cameras[current_controller].draw_camera_logic = true

	if cameras[current_controller] == null:
		for index in len(cameras):
			if null != cameras[index]:
				current_controller = index
				cameras[current_controller].make_current()
					
			
		
	
