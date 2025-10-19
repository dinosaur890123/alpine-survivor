extends Node
@onready var stamina_bar = $StaminaBar
@onready var warmth_bar = $WarmthBar
@onready var hunger_bar = $HungerBar
@onready var hotbar_container = $HotbarContainer
@onready var stamina_label = $StaminaBar/StaminaLabel
@onready var warmth_label = $WarmthBar/WarmthLabel
@onready var hunger_label = $HungerBar/HungerLabel
var selected_stylebox = preload("res://selected_slot_style.tres")
var default_stylebox = preload("res://default_slot_style.tres")
func _process(delta):
	stamina_bar.max_value = PlayerStats.max_stamina
	stamina_bar.value = PlayerStats.current_stamina
	warmth_bar.max_value = PlayerStats.max_warmth
	warmth_bar.value = PlayerStats.current_warmth
	hunger_bar.max_value = PlayerStats.max_hunger
	hunger_bar.value = PlayerStats.current_hunger
	for i in range(hotbar_container.get_child_count()):
		var slot_panel = hotbar_container.get_child(i)
		var item_name_label = slot_panel.get_node("ItemName")
		var item_quantity_label = slot_panel.get_node("ItemQuantity")
		var item_data = PlayerStats.hotbar[i]
		if item_data != null:
			item_name_label.text = item_data["item_name"].capitalize()
			item_quantity_label.text = str(item_data["quantity"])
			item_name_label.visible = true
			item_quantity_label.visible = true
		else:
			item_name_label.visible = false
			item_quantity_label.visible = false
		if i == PlayerStats.selected_hotbar_slot:
			slot_panel.add_theme_stylebox_override("panel", selected_stylebox)
		else:
			slot_panel.add_theme_stylebox_override("panel", default_stylebox)
