extends Node
# Player stats stuff
var max_stamina: float = 100.0
var current_stamina: float = 100.0
var max_warmth: float = 100.0
var current_warmth: float = 100.0
var max_hunger: float = 100.0
var current_hunger: float = 100.0
#Day/Night cycle
var day_length_in_seconds = 600.0
var time_of_day: float = 0.0
var is_night: bool = false
var sun: DirectionalLight3D
var world_environment: WorldEnvironment
# other stuff
var is_sheltered: bool = false
var warmth_zones: int = 0
var inventory = {"stick": 10, "rock": 5}
var recipes = {
	"campfire": {"stick": 2, "rock": 1}
}
var hotbar = [null, null, null, null, null]
var selected_hotbar_slot: int = 0
func ready():
	var slot_index = 0
	for item_name in inventory:
		if slot_index < hotbar.size():
			hotbar[slot_index] = {"item_name": item_name, "quantity": inventory[item_name]}
			slot_index += 1
func _process(delta):
	update_day_night_cycle(delta)
	current_hunger -= 0.5 * delta
	if not is_sheltered and warmth_zones <= 0:
		current_warmth -= 1.0 * delta
	
	if not Input.is_action_pressed("sprint") and current_stamina < max_stamina:
		current_stamina += 5 * delta
	current_hunger = max(0, current_hunger)
	current_warmth = max(0, current_warmth)
	current_stamina = clamp(current_stamina, 0, max_stamina)
	if current_hunger == 0 or current_warmth == 0:
		print("Game Over!")
		get_tree().reload_current_scene()
func setup_environment(sun_node: DirectionalLight3D, env_node: WorldEnvironment):
	sun = sun_node
	world_environment = env_node
func update_day_night_cycle(delta):
	time_of_day = fmod(time_of_day + delta, day_length_in_seconds)
	var cycle_progress = time_of_day / day_length_in_seconds
	if sun:
		sun.rotation_degrees.x = cycle_progress * 360 - 90
	if cycle_progress > 0.5:
		if not is_night:
			is_night = true
			print("The sun sets. It is now night.")
		if world_environment:
			world_environment.environment.ambient_light_energy = 0.1
func is_player_safe() -> bool:
	return is_sheltered or warmth_zones > 0
func add_to_inventory(item_name):
	if inventory.has(item_name):
		inventory[item_name] += 1
	else:
		inventory[item_name] = 1
	print("Inventory: ", inventory)
func remove_from_inventory(item_name):
	if inventory.has(item_name) and inventory[item_name] > 0:
		inventory[item_name] -= 1
		if inventory[item_name] == 0:
			inventory.erase(item_name)
		print("Inventory: ", inventory)
		return true
	return false
func enter_warmth_zone():
	warmth_zones += 1
	print("Entered warmth zone. Total zones: ", warmth_zones)

func exit_warmth_zone():
	warmth_zones -= 1
	print("Exited warmth zone. Total zones: ", warmth_zones)
