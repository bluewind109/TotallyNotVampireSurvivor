extends Node2D
## State Machine using callable
## Source code from FireBelley: 
## https://gist.github.com/firebelley/96f2f82e3feaa2756fe647d8b9843174 
class_name CallableStateMachine

var state_dictionary: Dictionary[String, CallableState] = {}
var current_state: String

func add_states(
	normal_state_callable: Callable,
	enter_state_callable: Callable,
	leave_state_callable: Callable
):
	state_dictionary[normal_state_callable.get_method()] = CallableState.new(
		normal_state_callable,
		enter_state_callable,
		leave_state_callable
	)

func set_initial_state(state_callable: Callable):
	var state_name = state_callable.get_method()
	if (state_dictionary.has(state_name)):
		_set_state.call_deferred(state_name)
	else:
		push_warning("no state found with name: ", state_name)

func _set_state(state_name: String):
	if (current_state):
		var leave_callable: Callable = state_dictionary[current_state].leave
		if (not leave_callable.is_valid()):
			leave_callable.call()
		
	current_state = state_name
	var enter_callable: Callable = state_dictionary[current_state].enter
	if (not enter_callable.is_null()):
		enter_callable.call()