extends CharacterBody3D
var interactable = null
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPRINT_SPEED = 8.0
@onready var animation_player = $"character-a2/AnimationPlayer"
@onready var camera_mount = $CameraMount
@onready var character_model = $"character-a2"
var campfire_scene = preload("res://campfire.tscn")
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
    if event is InputEventMouseMotion:
        self.rotate_y(-event.relative.x * 0.005)
        camera_mount.rotate_x(-event.relative.y * 0.005)
        camera_mount.rotation_degrees.x = clamp(camera_mount.rotation_degrees.x, -70.0, 70.0)
    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if Input.is_action_just_pressed("interact"):
        if interactable != null:
            animation_player.play("pick-up")
            interactable.interact()
    if Input.is_action_just_pressed("craft_campfire"):
        var recipe = {"stick": 2, "rock": 1}
        var can_craft = true
        for item in recipe:
            if not PlayerStats.inventory.has(item) or PlayerStats.inventory[item] < recipe[item]:
                can_craft = false
                break
        if can_craft:
            print("Crafting a campfire!")
            for item in recipe:
                PlayerStats.inventory[item] -= recipe[item]
                var new_campfire = campfire_scene.instantiate()
                get_tree().root.add_child(new_campfire)
                new_campfire.global_transform.origin = character_model.global_transform.origin + character_model.global_transform.basis.z * -2.0
        else:
            print("Not enough resources to craft a campfire. Need 2 sticks and 1 rock.")

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
