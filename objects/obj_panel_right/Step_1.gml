/// @description Insert description here
event_inherited();

relativeX = x - room_width;
baseX = window_get_width() - (window_get_width() - 320 * obj_editor_gui.realPortScaleHor)/2 + 1 + room_width;
y = 242;

if relativeMouseX <= relativeX  && relativeMouseX >= relativeX - 21 {
	if relativeMouseY >= y - 62 && relativeMouseY <= y + 58 {
		if mouse_check_button_pressed(mb_left) {
			// Dragging
			select = true;
			mouseClickOff = relativeMouseX - relativeX;
			
			// Double clicking
			doubleClickCounter += 1;
			
			image_index = 1;
		}
	}
}

if select {
	if !mouse_check_button(mb_left) {
		select = false;
		
		moveToX = round( (relativeMouseX - mouseClickOff + 1) / 10) * 10 + 1 + room_width;
		if moveToX < baseX + 30 && moveToX >= baseX - 30 {
			moveToX = baseX;
		}
		if moveToX >= baseX + 30 {
			moveToX = view_wport[1] + room_width;
		}
		
		if x > moveToX {
			moveDirection = -1;
		} else {
			moveDirection = 1;
		}
		
		moveToSpd = abs(moveToX - x) / 2;
		
		image_index = 0;
	}
} else {
	// Double clicking
	alarm[0] = 12;
	
	if doubleClickCounter >= 2 {
		doubleClickCounter = 0;
		
		if x != baseX {
			moveToX = baseX;
			moveToSpd = abs(x - baseX) / 7;
		} else {
			moveToX = view_wport[1] + room_width;
			moveToSpd = 26;
		}
		
		// Minimum speed
		if moveToSpd < 13 {
			moveToSpd = 13;
		}
		
		if x > moveToX {
			moveDirection = -1;
		} else {
			moveDirection = 1;
		}
	}
	
	if x != moveToX {
		if abs(moveToX - x) < moveToSpd * 1.8 {
			if moveToSpd > moveToSpdMin {
				moveToSpd /= moveToDeccel;
			} else {
				moveToSpd = moveToSpdMin;
			}
		}
		
		if moveDirection = -1 {
			if x > moveToX + moveToSpd {
				x -= moveToSpd;
				calculateHeight = true;
			} else {
				x = moveToX;
				moveToSpd = 0;
			}
		} else {
			if x < moveToX - moveToSpd  {
				x += moveToSpd;
			} else {
				x = moveToX;
				moveToSpd = 0;
			}
		}
	}
}

if select {
	dragX = relativeMouseX - mouseClickOff + room_width;
	dragXTemp = dragX;
	calculateHeight = true;
	
	x = dragX;
}

if calculateHeight {
	tempHeight = 3;
	
	for (i = 0; i < instance_number(obj_panel_button); i += 1) {
		tempTrg = instance_find(obj_panel_button,i);
		
		if tempTrg.viewOn = 3 { // If this button draws to the right panel
			tempHeight += 45;
		}
	}
	
	panelHeight = tempHeight;
	calculateHeight = false;
}

if mouse_check_button_released(mb_left) {
	if obj_editor_gui.sidePanelCtrl = 1 {
		with obj_panel_left {
			moveToSpd = abs(moveToX - x) / 2;
			moveToX = round((relativeX - 1) / 10) * 10 - 1 + room_width;
		}
	}
}

relativeX = x - room_width;

// On base
if x = baseX {
	onBase = 1;
} else {
	onBase = 0;
}

if relativeX = view_wport[1] {
	onBase = 2;
}

// Boundaries
if x < 235 + room_width {
	x = 235 + room_width;
}
if x > view_wport[1] + room_width {
	x = view_wport[1] + room_width;
}

// Pushing other panel
/*if x - 23 < obj_panel_left.x + 20 && select {
	if obj_editor_gui.sidePanelCtrl = -1 {
		obj_editor_gui.sidePanelCtrl = 1;
		trgXOrigin = obj_panel_left.x;
	}
}
if obj_editor_gui.sidePanelCtrl = 1 {
	obj_panel_left.x = self.x - 40;
	
	if obj_panel_left.x > trgXOrigin {
		obj_panel_left.x = trgXOrigin;
	}
}*/

// Scrollbars
scrollHorLeftBound = x;
scrollHorRightBound = view_wport[1] - 17 + room_width;
scrollHorTopBound = obj_panel_top.y + 11;
scrollHorBotBound = obj_panel_top.y + 26;

scrollVerRightBound = view_wport[1] - 1 + room_width;
scrollVerLeftBound = view_wport[1] - 16 + room_width;
scrollVerTopBound = obj_panel_top.y + 27;
scrollVerBotBound = obj_panel_bot.y - 1;

// Squish when panel offers less space than needed
if relativeX >= view_wport[1] - 16 {
	scrollPanelSquish = (relativeX - view_wport[1] - 16) * 2 + room_width;
} else {
	scrollPanelSquish = 0;
}

// Viewports
camera_set_view_pos(obj_editor_gui.cameraRightPanel,room_width + view_wport[1] + 1,0);
camera_set_view_size(view_camera[3], view_wport[1] - 16 - relativeX, scrollVerBotBound - scrollVerTopBound);

view_set_wport(3,view_wport[1] - 16 - relativeX);
if view_wport[3] < 0 {
	view_set_wport(3,0);
}

view_set_hport(3,scrollVerBotBound - scrollVerTopBound);
view_set_xport(3,relativeX - 1);
view_set_yport(3,scrollVerTopBound);

switch obj_editor_gui.mode {
	// Collision mode
	case 0:
		if relativeX < view_wport[1] - 16 {
			view_set_visible(3,true);
		} else {
			view_set_visible(3,false);
		}
		
		break;
	
	// Wireframe mode
	case 1:
		if relativeX < view_wport[1] - 16 {
			view_set_visible(3,true);
		} else {
			view_set_visible(3,false);
		}
		
		break;
	
	// Tiling mode
	case 3:
		if relativeX < view_wport[1] - 16 && obj_big_button_tiling.spawnButtons {
			view_set_visible(3,true);
			
			//camera_set_view_pos(obj_editor_gui.cameraRightPanel,tilesSheetPlacement+(scrollHorX-x)/scrollHorFactor,86+(scrollVerY-86)/scrollVerFactor);
		} else {
			view_set_visible(3,false);
		}
		
		break;
	
	// Trigger mode
	case 4:
		if relativeX < view_wport[1] - 16 {
			view_set_visible(3,true);
		} else {
			view_set_visible(3,false);
		}
		
		break;
	
	// Other mode
	default:
		view_set_visible(3,false);
		
		break;
}

if !visible {
	view_set_visible(3,false);
}