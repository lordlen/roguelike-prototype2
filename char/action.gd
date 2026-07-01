@abstract class_name Action
extends RefCounted

signal action_finished

# returns true if turn ended, but false if not
@abstract func execute() -> bool
