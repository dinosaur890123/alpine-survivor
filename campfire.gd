extends Area3D
func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    $Timer.timeout.connect(_on_timer_timeout)
func _on_body_entered(body):
    if body.is_in_group("player"):
        PlayerStats.enter_warmth_zone()
func _on_body_exited(body):
    if body.is_in_group("player"):
        PlayerStats.exit_warmth_zone()
func _on_timer_timeout():
    var bodies = get_overlapping_bodies()
    for body in bodies:
        if body.is_in_group("player"):
            PlayerStats.exit_warmth_zone()
            break
    queue_free()
