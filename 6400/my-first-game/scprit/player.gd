extends CharacterBody2D

@export var moveSpeed : float = 50
# Called when the node enters the scene tree for the first time.
@export var animator : AnimatedSprite2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left" , "right" , "up" , "down") * moveSpeed
	
	if velocity == Vector2.ZERO:
		animator.play("idle")
	else:
		animator.play("run")
	move_and_slide()
	
