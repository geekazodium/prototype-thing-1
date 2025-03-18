extends Node

@export var dash_action: String = "";
@export var input_direction: InputDirection = null;
@export var dash_speed: float = 1000;
@export var dash_timer: Timer = null;
@export var dash_cooldown_timer: Timer = null;

func _physics_process(_delta: float) -> void:
	if !self.dash_cooldown_timer.is_stopped():
		return;
	if Input.is_action_just_pressed(self.dash_action):
		var character_body: PlatformerPlayerBody2D = self.get_parent();
		character_body.velocity = self.input_direction.get_direction() * self.dash_speed;
		character_body.set_gravity_multiplier(0);
		self.dash_timer.start();
		self.dash_cooldown_timer.start();

func reset_after_dash():
	var character_body: PlatformerPlayerBody2D = self.get_parent();
	character_body.reset_gravity_multiplier();
	character_body.velocity *= .5;
