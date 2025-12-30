extends Node

@onready var delivery_timer := 30.0

@onready var point: int = 0: set = update_malus
@onready var actual_malus: int = -1
@onready var counter: int = 0

@onready var weight_malus = 0.8

@onready var actual_slippery_factor := 0.1

@onready var no_arrow_timer := 2.0
@onready var min_sec_no_arrow_timer: float = 5.0
@onready var max_sec_no_arrow_timer: float = 10.0

@onready var inverted_arrow_timer := 5.0
@onready var min_sec_inverted_arrow_timer: float = 5.0
@onready var max_sec_inverted_arrow_timer: float = 10.0


func update_malus(new_point: int):
	point = new_point
	counter += 1
	
	if counter == 10:
		counter = 0
		
		update_weight_malus()
		update_slippery_malus()
		update_arrow_timers()
		update_inverted_arrows()


func update_weight_malus() -> void:
	if weight_malus != 0.1:
		weight_malus -= 0.05


func update_slippery_malus() -> void:
	if actual_slippery_factor != 1.0:
		actual_slippery_factor += 0.05


func update_arrow_timers() -> void:
	if no_arrow_timer != 10.0:
		no_arrow_timer += 0.5
	
	if min_sec_no_arrow_timer >= 0.1:
		min_sec_no_arrow_timer -= 0.5
	else:
		min_sec_no_arrow_timer = 0.1
	
	max_sec_no_arrow_timer -= 1.0
	if max_sec_no_arrow_timer == min_sec_no_arrow_timer:
		max_sec_no_arrow_timer = min_sec_no_arrow_timer + 0.5


func update_inverted_arrows() -> void:
	if inverted_arrow_timer != 20.0:
		inverted_arrow_timer += 0.5
	
	if min_sec_inverted_arrow_timer >= 0.1:
		min_sec_inverted_arrow_timer -= 0.5
	else:
		min_sec_inverted_arrow_timer = 0.1
	
	max_sec_inverted_arrow_timer -= 1.0
	if max_sec_inverted_arrow_timer == min_sec_inverted_arrow_timer:
		max_sec_inverted_arrow_timer = min_sec_inverted_arrow_timer + 0.5
