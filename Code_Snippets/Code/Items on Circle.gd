for number in amount:
	var NewPosition = Vector2()
	var NewIcon = Sprite2D.new()
	NewIcon.texture = icon
	add_child(NewIcon)
	
	NewPosition = Vector2(radius, 0)
	NewPosition = NewPosition.rotated((TAU/amount)*number)
	NewPosition = NewPosition.rotated(randf_range(-offset,offset))
	
	NewIcon.position = NewPosition
