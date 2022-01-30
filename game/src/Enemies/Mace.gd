extends Actor
class_name Mace
onready var rayCast = $RayCast2D
onready var collider = $CollisionShape2D
var is_on_ground
var is_going
var direction: = Vector2.ZERO
var is_died := false
var is_following := false
signal signal_mace_on_floor
# Called when the node enters the scene tree for the first time.
func _ready():
	#print_debug("ready update is_going = false and ray cast add exception self")
	#rayCast.add_exception(self)
	is_going  = false

func _physics_process(delta: float) -> void:
	if is_on_floor():
		is_died = true
		mace_on_floor()
		start_follow_player()
	
	var object = rayCast.get_collider()
	if object is KinematicBody2D and !object.is_in_group("Mace"):
		#print(object.get_class() + "-" + self.name + " raycast get collider return collied with body " + object.name)
		if not is_going:
			is_going = true
	
	if is_going:
		go_to_floor()

func mace_on_floor():
	emit_signal("signal_mace_on_floor")

func start_follow_player():
	if not is_following:
		print_debug("on floor and start following")
		is_following = true
		$Sprite/AnimationPlayer.play("destroy")

func destroy():
	print_debug("destroy")
	$Tween.interpolate_property(self ,"position", self.position, Vector2(self.position.x + 400, self.position.y), 0.8, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.start()
	
func go_to_floor():
	
	direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)

func get_direction() -> Vector2:
	var direction_y: = 0.0
	if not is_on_floor():
		direction_y = 100
	else:
		direction_y = 0.0
	
	return Vector2(
		#Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0, #fixed speed X = run_speed
		direction_y
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var velocity: = linear_velocity
	if is_died:
		return velocity
	else:
		#velocity.x = speed.x * direction.x
		velocity.x = 0
		if direction.y != 0.0:
			velocity.y = speed.y * direction.y
		return velocity
