extends Area3D

func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body):
    if body.is_in_group("player"):
        PlayerStats.is_sheltered = true
        print("Player entered shelter.")

func _on_body_exited(body):
    if body.is_in_group("player"):
        PlayerStats.is_sheltered = false
        print("Player exited shelter.")
