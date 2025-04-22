extends Resource
class_name BaseProjectileStrategy

var title: String
var description: String

## Update upgrade description. Damn it rhymes.
func update_desc():
	# Base func
	pass

func get_desc() -> String:
	# Base func
	return description

## Apply upgrade to projectile
func apply_upgrade(projectile: Projectile):
	return projectile
