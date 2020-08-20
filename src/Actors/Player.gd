extends Actor

enum STATES {
    MoveRight,
    MoveLeft,
    Jump
    Idle
}

onready var state = STATES.Idle

export var stomp_impulse = 1000.0

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
    _velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
    
func _on_EnemyDetector_body_entered(body: Node) -> void:
    die()
    
func _physics_process(delta: float) -> void:
    var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
#    var direction = get_direction()
#    _velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
#    _velocity = move_and_slide(_velocity, FLOOR_NORMAL)
     
    _velocity.y += gravity * get_physics_process_delta_time()

    match state: 
        STATES.MoveRight:
            print("move right")
            _velocity.x = min(_velocity.x + 300, 500)
        STATES.MoveLeft:
            print("move left")
            _velocity.x = max(_velocity.x - 300, -500)
#        STATES.Jump:
#            print("jump")
        STATES.Idle:
            _velocity.x = 0
            
    move_and_slide(_velocity, FLOOR_NORMAL)
    
func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            var local_event = make_input_local(event)

            if local_event.position.x > 100:
                state = STATES.MoveRight
            elif local_event.position.x < -100:
                state = STATES.MoveLeft
#            elif local_event.position.y in range(-100, -50):
#                state = STATES.Jump
    else:
        state = STATES.Idle
    
    
#func get_direction() -> Vector2:
#    return Vector2(
#            Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
#            -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
#    )

#func calculate_move_velocity(
#        linear_velocity: Vector2,
#        direction: Vector2,
#        speed: Vector2,
#        is_jump_interrupted: bool
#    ) -> Vector2:
#        var out = linear_velocity
#        out.x = speed.x * direction.x
#        out.y += gravity * get_physics_process_delta_time()
#
#        if direction.y == -1.0:
#            out.y = speed.y * direction.y
#
#        if is_jump_interrupted:
#            out.y = 0.0
#
#        return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
    var out: = linear_velocity
    out.y = -impulse
    return out
    
func die() -> void:
    PlayerData.deaths += 1
    queue_free()
    
    
    




