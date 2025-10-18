extends Node
var max_stamina: float = 100.0
var current_stamina: float = 100.0
var max_warmth: float = 100.0
var current_warmth: float = 100.0
var max_hunger: float = 100.0
var current_hunger: float = 100.0

var is_sheltered: bool = false
var warmth_zones: int = 0
var inventory = {}
var recipes = {
    "campfire": {"stick": 2, "rock": 1}
}
func _process(delta):
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
