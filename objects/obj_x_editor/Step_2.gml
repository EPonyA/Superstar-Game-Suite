/// @description 
event_inherited();

if instance_exists(trg) {
	if select = 0 {
		// Bottom left corner
		if trg.height > 1 {
			y = trg.y + trg.height*20 - 20;
		} else {
			y = trg.y + 20;
		}
		
		if trg.width > 2 {
			x = trg.x;
		} else {
			x = trg.x - 20;
		}
	}
}
