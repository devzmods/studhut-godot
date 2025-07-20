extends CharacterBody3D

@export var move_speed: float = 5.0
@export var look_sens: float = 0.2

@onready var pivot: Node3D = $pivot

func _input(event: InputEvent) -> void:
	var look_enabled: bool = Input.is_action_pressed("enable_look")
	
	if look_enabled and event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * look_sens)
		pivot.rotate_x(deg_to_rad(-event.relative.y) * look_sens)

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var vertical_dir: float = Input.get_axis("move_down", "move_up")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, vertical_dir, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		velocity.y = direction.y * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
		velocity.y = move_toward(velocity.y, 0, move_speed)

	move_and_slide()
