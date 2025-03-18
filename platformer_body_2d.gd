extends CharacterBody2D

@export var horizontal_accel_speed: float;
@export var max_walk_speed: float;
@export var jump_y_vel: float;
@export var reverse_boost: float;
@export var air_friction: float;
@export var leading_jump_buffer: float;
var jump_timer: float;
@export var trailing_jump_buffer: float;
var ground_timer: float;
@export var move_left_action: String;
@export var move_right_action: String;
@export var jump_input: String;

func _process(_delta: float):
	if Input.is_action_just_pressed(self.jump_input):
		self.jump_timer = self.leading_jump_buffer;

func _physics_process(delta: float):
	if self.jump_timer > 0.:
		self.jump_timer -= delta;
		
	if self.ground_timer > 0.:
		self.ground_timer -= delta;
	
	if self.is_on_floor():
		self.ground_timer = self.trailing_jump_buffer;
	
	var up = self.get_up_direction();
	var left = Vector2(up.y, -up.x);
	var temp_velocity = self.get_velocity();
	
	var delta_v = Vector2(0., 0.);
	var x_axis = Input.get_axis(self.move_left_action, self.move_right_action);
	if x_axis != 0:
		var distance_from_max_v = self.max_walk_speed + left.dot(temp_velocity) * x_axis;
		if distance_from_max_v > 0.:
			if distance_from_max_v < self.horizontal_accel_speed * delta :
				delta_v += -x_axis * left * (distance_from_max_v / delta);
			else:
				delta_v += -x_axis * self.horizontal_accel_speed * left;
	else:
		if self.is_on_floor():
			delta_v += -temp_velocity.project(left) * self.reverse_boost;
	delta_v += self.get_gravity();
	delta_v += -temp_velocity * self.air_friction;

	var delta_v_instant = Vector2(0., 0.);

	if (self.jump_timer > 0.) && (self.ground_timer > 0.):
		self.jump_timer = 0.;
		self.ground_timer = 0.;
		delta_v_instant += up * self.jump_y_vel;
		delta_v_instant += -temp_velocity.project(up);
	
	self.set_velocity(temp_velocity + delta_v * delta + delta_v_instant);
	self.move_and_slide();
