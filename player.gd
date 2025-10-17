extends CharacterBody3D
var interactable = null
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPRINT_SPEED = 8.0
@onready var animation_player = $"character-a2/AnimationPlayer"
@onready var camera_mount = $CameraMount
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * 0.005)
        camera_mount.rotate_x(-event.relative.y * 0.005)
        camera_mount.rotation.x = clamp(camera_mount.rotation.x, -1.2, 1.2)

    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if Input.is_action_just_pressed("interact"):
        if interactable != null:
            animation_player.play("pick-up")
            interactable.interact()

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    var current_speed = SPEED
    if Input.is_action_pressed("sprint") and PlayerStats.current_stamina > 0:
        current_speed = SPRINT_SPEED
        PlayerStats.current_stamina -= 10 * delta 
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
        $"character-a2".look_at(position + direction)
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
    move_and_slide()
    update_animation(direction)
func update_animation(move_direction):
    if move_direction != Vector3.ZERO:
        if Input.is_action_pressed("sprint"):
            animation_player.play("sprint")
        else:
            animation_player.play("walk")
    else:
        animation_player.play("idle")
func _on_interaction_area_area_entered(area):
    if area.has_method("interact"):
        interactable = area
func _on_interaction_area_area_exited(area):
    if area == interactable:
        interactable = null
func _on_area_3d_body_entered(body: Node3D) -> void:
    pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
    pass # Replace with function body.
