extends Actor
class_name Enemy

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	if is_on_wall():
		_velocity.x *= -1
		if not $Sprite.flip_h:
			$Sprite.flip_h = true
			$Sprite.scale.x = -1*$Sprite.scale.x
	else:
		_velocity.x *= 1
		if $Sprite.flip_h:
			$Sprite.flip_h = false
			$Sprite.scale.x = 1*$Sprite.scale.x

	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
