extends Area2D

@export var item_type : String = "rapid_fire"
@export var fall_speed : float = 80.0

func _ready() -> void:
	print("item_type is: ", item_type)
	var sprite = $AnimatedSprite2D
	match item_type:
		"rapid_fire":
			sprite.play("rapid_fire")  
		"triple_shot":
			sprite.play("triple_shot")

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	# 超出屏幕自动删除
	if position.y > 600:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("pick_up"):
		body.pick_up(item_type)
		queue_free()
