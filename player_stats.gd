extends Node
var max_stamina: float = 100.0
var current_stamina: float = 100.0
var max_warmth: float = 100.0
var current_warmth: float = 100.0
var max_hunger: float = 100.0
var current_hunger: float = 100.0
var is_sheltered: bool = false
func _process(delta):
	current_hunger -= 0.5 * delta
	if not is_sheltered:
		current_warmth -= 1.0 * delta
	current_warmth -= 1.0 * delta
	current_hunger = max(0, current_hunger)
	current_warmth = max(0, current_warmth)
	current_stamina = max(0, current_stamina)
	if current_hunger == 0 or current_warmth == 0:
		print("Game Over!")
		get_tree().reload_current_scene()
func _on_shelter_area_body_entered(body):
	if body.is_in_group("player"):
		is_sheltered = true
		print("Player entered shelter")

func _on_shelter_area_body_exited(body):
	if body.is_in_group("player"):
		is_sheltered = false
		print("Player exited shelter")
