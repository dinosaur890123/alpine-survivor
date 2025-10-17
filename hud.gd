extends Node
@onready var stamina_bar = $StaminaBar
@onready var warmth_bar = $WarmthBar
@onready var hunger_bar = $HungerBar
func _process(delta):
	stamina_bar.max_value = PlayerStats.max_stamina
	stamina_bar.value = PlayerStats.current_stamina
	warmth_bar.max_value = PlayerStats.max_warmth
	warmth_bar.value = PlayerStats.current_warmth
	hunger_bar.max_value = PlayerStats.max_hunger
	hunger_bar.value = PlayerStats.current_hunger
