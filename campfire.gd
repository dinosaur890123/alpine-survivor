extends Area3D
var fuel: float = 100.0
var is_lit: bool = true
var is_player_inside: bool = false
@onready var light = $OmniLight3D
func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
func _process(delta):
    if is_lit:
        fuel -= delta * 5.0 
        light.light_energy = lerp(0.0, 5.0, fuel / 100.0) 
        if fuel <= 0:
            extinguish_fire()
func interact():
    if PlayerStats.inventory.has ("stick") and PlayerStats.inventory["stick"] > 0:
        PlayerStats.remove_from_inventory("stick")
        fuel = min(fuel + 50.0, 100.0)
        print("Fed the fire. Fuel is now: ", fuel)
        if not is_lit:
            light_fire()
        else:
            print('No sticks to fuel the fire')
func light_fire():
    is_lit = true
    light.visible = true
    if is_player_inside:
        PlayerStats.enter_warmth_zone()
    print("The campfire is lit.")
func extinguish_fire():
    is_lit = false
    fuel = 0
    light.visible = false
    print("The campfire has burned out.")
    if is_player_inside:
        PlayerStats.exit_warmth_zone()
func _on_body_entered(body):
    if body.is_in_group("player"):
        is_player_inside = true
        if is_lit:
            PlayerStats.enter_warmth_zone()
func _on_body_exited(body):
    if body.is_in_group("player"):
        is_player_inside = false
        if is_lit:
            PlayerStats.exit_warmth_zone()
