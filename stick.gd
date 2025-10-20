extends Area3D
var item_name = "stick"
func interact():
	PlayerStats.add_to_inventory(item_name)
	print("Picked up a stick.")
	queue_free()
