extends Area3D
var hunger_restored = 25.0
func interact():
	PlayerStats.current_hunger += hunger_restored
	PlayerStats.current_hunger = min(PlayerStats.current_hunger, PlayerStats.max_hunger)
	print("Ate berries! Hunger is now: ", PlayerStats.current_hunger)
	queue_free()
