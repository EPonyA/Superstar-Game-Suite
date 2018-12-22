/// @description Insert description here
event_inherited();

y = obj_panel_top.y - 57;

if !mouse_check_button(mb_left) {
	imgIndex = 0;
}

if select {
	// Slide side panels out
	if obj_panel_left.moveToSpd = 0 && obj_panel_right.moveToSpd = 0 {
		global.tempXLeft = obj_panel_left.x;
		global.tempXRight = obj_panel_right.x;
	}
	
	obj_panel_left.moveToX = 0;
	obj_panel_left.moveToSpd = global.tempXLeft/4;
	obj_panel_left.moveDirection = -1;
				
	obj_panel_right.moveToX = 1024;
	obj_panel_right.moveToSpd = (1024 - global.tempXRight)/4;
	obj_panel_right.moveDirection = 1;
	
	select = false;
	alarm[0] = 16;
}