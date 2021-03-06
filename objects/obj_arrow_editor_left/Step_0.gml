/// @description 
event_inherited();

// Selecting
if mouseCheckX >= self.x - sprite_width && mouseCheckX <= self.x && mouseCheckY >= self.y - sprite_height/2 && mouseCheckY <= self.y + sprite_height/2 {
	if mouse_check_button_pressed(mb_left) {
		if canSelect {
			select = true;
		}
	}
}

if instance_exists(trg) {
	if select {
		if floor(mouseCheckX/20)*20 + 20 >= 0 {
			if mouseCheckX < trg.x + trg.width*20 - 20 {
				x = floor(mouseCheckX/20)*20 + 20;
				
				if self.x < trg.x {
					tempWidth = trg.x + trg.width*20;
					trg.x = self.x;
					trg.width = (tempWidth - trg.x)/20;
					limitOn = false;
					
					if trg.str = "slope1" {
						trg.y = trg.lastY + trg.width*20 - (trg.zfloor-trg.zcieling)*20 - trg.height*20;
					}
					if trg.str = "slope2" {
						trg.y = trg.lastY + trg.width*20 - (trg.zfloor-trg.zcieling)*20 - trg.height*20;
					}
				}
				
				if self.x > trg.x {
					tempWidth = trg.x + trg.width*20;
					trg.x = self.x;
					trg.width = (tempWidth - trg.x)/20;
					limitOn = false;
					
					if trg.str = "slope1" {
						trg.y = trg.lastY + trg.width*20 - (trg.zfloor-trg.zcieling)*20 - trg.height*20;
					}
					if trg.str = "slope2" {
						trg.y = trg.lastY + trg.width*20 - (trg.zfloor-trg.zcieling)*20 - trg.height*20;
					}
				}
				
				trg.tilingX = trg.x - 20;
				
				if trg.object_index = obj_editor_staircase {
					with trg {
						event_user(1);
						bakeRaster = true;
					}
				}
				
				trg.resetArray = true;
			}
		}
	}
}
