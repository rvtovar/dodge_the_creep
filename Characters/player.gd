extends Area2D

@export var speed = 400
var screen_size
signal hit
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	var vel = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	if Input.is_action_pressed("move_down"):
		vel.y +=1
	if Input.is_action_pressed("move_up"):
		vel.y -=1

	if vel.length() > 0:
		vel = vel.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += vel * delta
	position = position.clamp(Vector2.ZERO,screen_size)

	if vel.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false

		$AnimatedSprite2D.flip_h = vel.x < 0
	elif vel.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = vel.y > 0


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
