extends Actor
class_name Player2

export var stomp_impulse: = 800.0
export var jump_force: = -0.9
export var mode_player: = "run"
export var player_texture:Resource = load("res://assets/player/player_001.png")
var run_speed: = 0
var direction: = Vector2.ZERO
var is_jump_interrupted: = 0.0
var max_jumps = 2
var jump_count = 0
signal jump
# dash
export (int) var dash_length = 1200
export (int) var dash_speed = 600
var dash_init_pos = Vector2()
var can_dash = true
var dash_gravity
var starting_dash = false
# AI sterring
#onready var agent := GSAIAgentLocation.new()
export var adjust_position_x := 10
export var alway_on_particales := false
# player state
enum {IDLE, RUN, JUMP, HURT, DEAD, DASH}
var is_on_starting = true
var state
var anim
var new_anim
var is_died := false
onready var animation_player = $AnimationPlayer
onready var particles2D = $Particles2D
onready var trail2D = $Smoothing2D/Sprite/Trail2D

func change_state(new_state):
	#print_debug("player change_state " + str(new_state))
	state = new_state
	match state:
		IDLE:
			idle()
		RUN:
			run()
		HURT:
			hurt()
		JUMP:
			jump_up()
		DASH:
			dash()
		DEAD:
			die()

func _ready():
	print_debug("player ready 2")
	$Smoothing2D/Sprite.texture = player_texture
	$Smoothing2D/Sprite/Trail2D.adjust_position_x = adjust_position_x
	change_state(IDLE)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	print_debug("_on_EnemyDetector_body_entered " + body.name)
	change_state(DEAD)

func _on_TrapDetector_area_entered(area):
	print_debug("_on_TrapDetector_area_entered " + area.name)
	if area.name == "Area2DTrap":
		change_state(DEAD)
		
func _on_WaterDetector_area_entered(area):
	print_debug("_on_WaterDetector_area_entered " + area.name)
	if area.name == "Water2D":
		change_state(DEAD)

func _physics_process(delta: float) -> void:
	if is_on_wall(): # or (is_on_ceiling() and gravity > 0)
		print_debug("on wall then go to die")
		change_state(DEAD)
		return
	
	if not can_dash:
		dash_process()
	elif Input.is_action_just_pressed("dash") or starting_dash:
		change_state(DASH)
		return
	#if gravity < 0 and  is_on_floor():
	#	jump_force *= -1

	is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)

	# AI sterring agent
	#agent.position = Vector3(global_position.x, global_position.y, 0)
	
	if is_on_starting:
		return

	if is_on_floor() and not is_died:
		change_state(RUN)
	elif !is_on_floor():
		change_state(JUMP)

func get_direction() -> Vector2:
	var direction_y: = 0.0
	if (is_on_floor() or is_on_ceiling() or mode_player == "fly") and Input.is_action_pressed("jump"):
		direction_y = jump_force #* gravity/gravity
	else:
		direction_y = 0.0
	
	return Vector2(
		#Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1, #fixed speed X = run_speed
		direction_y
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	if is_died:
		return velocity
	else:
		#velocity.x = speed.x * direction.x
		velocity.x = run_speed
		if direction.y != 0.0:
			velocity.y = speed.y * direction.y
		if is_jump_interrupted:
			velocity.y = 0.0
		return velocity

func hurt():
	new_anim = 'hurt'

func die() -> void:
	print_debug("go to die")
	is_died = true
	
	animation_player.play("die")
	
	var t = Timer.new()
	t.set_wait_time(0.99)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	PlayerData.deaths += 1
	queue_free()

func idle():
	new_anim = 'idle'
	
	can_dash = true
	
	run_speed = 0
	
	if new_anim != anim:
		anim = new_anim
		animation_player.play(new_anim)

func run():
	new_anim = 'run'

	can_dash = true
	
	run_speed = 600
	
	if !particles2D.emitting:
		particles2D.emitting = true
	elif trail2D.is_emitting:
		trail2D.set_emitting(false)
	
	if new_anim != anim:
		anim = new_anim
		animation_player.play(new_anim)

func jump_up():
	new_anim = 'jump_up'

	if particles2D.emitting and not alway_on_particales:
		particles2D.emitting = false
	elif not trail2D.is_emitting:
		trail2D.set_emitting(true)
	
	if new_anim != anim:
		anim = new_anim
		animation_player.play(new_anim)


func done_starting():
	is_on_starting = false
	change_state(RUN)

func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)

func _on_StompDetector_area_entered(area: Area2D) -> void:
	print_debug("_on_StompDetector_area_entered " + area.name)
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)


func _on_Mace_signal_mace_on_floor():
	$Camera2D.shake_amount = 0.3


func _on_RawDetector_area_exited(area):
	print_debug("_on_RawDetector_area_exited " + area.name)
	change_state(DEAD)


func _on_RayCast2D_revert_gravity():
	gravity = gravity * -1

# Dash
func dash():
	starting_dash = false
	if can_dash:
		print_debug("dash")
		# locked dash
		can_dash = false
		
		# new animation
		new_anim = 'dash'
		
		if new_anim != anim:
			anim = new_anim
			animation_player.play(new_anim)
		
		# back up current state
		dash_init_pos = self.position
		dash_gravity = self.gravity
		
		# skip current state
		self.gravity = 0
		self._velocity.y = 0
		
		# update speed X
		self._velocity.x = dash_speed * self.direction.x
		#actor.emit_signal("action_performed", "dash")

func dash_process():
	# runout of dash_length then stop dash and change state to init state then RUN
	if abs(dash_init_pos.x - self.position.x) >= dash_length:
		self.gravity = dash_gravity
		change_state(RUN)
		return


func _on_DashRing_dash_ring_entered():
	if not starting_dash:
		starting_dash = true
