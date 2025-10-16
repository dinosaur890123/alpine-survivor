# player.gd
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_mount = $CameraMount

func _ready():
    # This captures the mouse so it doesn't leave the game window.
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle Jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # NEW DEBUG STEP: Check for a single action directly.
    if Input.is_action_pressed("move_forward"):
        print("Forward key is pressed!")

    # Get the input direction and handle the movement/deceleration.
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    
    # This is the debug print you were using.
    print(input_dir)

    # We use the camera's basis to move relative to where the camera is looking
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
        # Make the character model face the direction of movement
        # Be sure to replace 'character-a2' with your actual model's name!
        $"character-a2".look_at(position + direction)
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()

func _input(event):
    # Mouse look
    if event is InputEventMouseMotion:
        # Horizontal rotation (around the y-axis)
        rotate_y(-event.relative.x * 0.005)
        # Vertical rotation for the camera mount
        camera_mount.rotate_x(-event.relative.y * 0.005)
        # Clamp vertical rotation to prevent flipping
        camera_mount.rotation.x = clamp(camera_mount.rotation.x, -1.2, 1.2)

    # Release mouse cursor on pressing Escape
    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
