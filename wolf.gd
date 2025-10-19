extends CharacterBody3D
enum State { IDLE, WANDER, CHASE, ATTACK }
var current_state = State.IDLE
const SPEED = 3.5
const CHASE_SPEED = 6.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player = null
@onready var nav_agent = $NavigationAgent3D
@onready var detection_area = $DetectionArea
@onready var attack_cooldown = $AttackCooldown
func _ready():
	player = get_tree().get_first_node_in_group("player")
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	set_physics_process(PlayerStats.is_night)
func _physics_process(delta):
	if !PlayerStats.is_night or PlayerStats.is_player_safe():
		print("The wolf retreats into the shadows.")
		queue_free()
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	match current_state:
		State.IDLE:
			current_state = State.WANDER
		State.WANDER:
			pass
		State.CHASE:
			if player:
				nav_agent.target_position = player.global_position
				var next_path_position = nav_agent.get_next_path_position()
				var direction = (next_path_position - global_position).normalized()
				velocity = direction * CHASE_SPEED
				look_at(player.global_position, Vector3.UP)
			else:
				current_state = State.IDLE
		State.ATTACK:
			velocity = Vector3.ZERO
			if attack_cooldown.is_stopped():
				print("Wolf attacks!")
				PlayerStats.current_health -= 25
				attack_cooldown.start()
				current_state = State.CHASE
	move_and_slide()
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		print("Wolf has spotted you!")
		current_state = State.CHASE
func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		print("You escaped the wolf's sight.")
		current_state = State.WANDER
