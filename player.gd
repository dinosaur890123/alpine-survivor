# player.gd
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_mount = $CameraMount

func _ready():
    # This captures the mouse so it doesn't leave the game window.
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
    # This function now handles mouse look and releasing the cursor.
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * 0.005)
        camera_mount.rotate_x(-event.relative.y * 0.005)
        camera_mount.rotation.x = clamp(camera_mount.rotation.x, -1.2, 1.2)

    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
    # Add gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle Jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # --- NEW INPUT LOGIC ---
    # We now check each action individually instead of using get_vector().
    var input_dir = Vector2.ZERO
    if Input.is_action_pressed("move_forward"):
        input_dir.y -= 1
    if Input.is_action_pressed("move_backward"):
        input_dir.y += 1
    if Input.is_action_pressed("move_left"):
        input_dir.x -= 1
    if Input.is_action_pressed("move_right"):
        input_dir.x += 1
    
    input_dir = input_dir.normalized() # Ensure consistent speed diagonally.

    # Calculate movement direction based on camera.
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
        # Make the character model face the direction of movement.
        # Be sure to replace 'character-a2' with your actual model's name!
        $"character-a2".look_at(position + direction)
    else:
        # If no input, slow down.
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()
