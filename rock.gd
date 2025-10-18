extends Area3D
var item_name = "rock"
func interact():
	PlayerStats.add_to_inventory(item_name)
	print("Picked up a rock.")
	queue_free()
