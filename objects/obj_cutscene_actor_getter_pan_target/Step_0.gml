/// @description Insert description here
relativeMouseX = floor((mouse_x + 195 - 23) / 10) * 5 - 80 + floor(camera_get_view_x(obj_editor_gui.cameraRealGame)/20)*20;
relativeMouseY = floor((mouse_y + 576) / 10) * 5 - 320 + 41 + floor(camera_get_view_y(obj_editor_gui.cameraRealGame)/20)*20;

if selectState = 0 {
	col1 = gray;
	col2 = orange;
	
	if mouse_check_button_pressed(mb_left) {
		// Click inside circle
		if relativeMouseX >= x - 11 && relativeMouseX <= x + 11 {
			if relativeMouseY >= y - 41 - 11 && relativeMouseY <= y - 41 + 11 {
				selectState = 1;
			}
		}
		
		// Click outside interface
		if !collision_point(relativeMouseX,relativeMouseY,obj_cutscene_actor_getter_pan_target,true,false) {
			// Pass all persistent values to obj_panel_bot
			obj_panel_bot.panAngle[timeIndex] = self.panAngle;
			obj_panel_bot.panMagnitude[timeIndex] = self.panMagnitude;
			obj_panel_bot.easeInVal[timeIndex] = self.easeInVal;
			obj_panel_bot.easeOutVal[timeIndex] = self.easeOutVal;
			
			obj_trigger_dialogue_region_editor.alarm[2] = 2;
			
			instance_destroy();
		}
	}
}

if selectState = 1 {
	col1 = orange;
	col2 = c_white;
	
	panAngle = point_direction(x,y-41,relativeMouseX,relativeMouseY);
	
	if mouse_check_button_pressed(mb_left) {
		selectState = 2;
	}
}

if selectState = 2 {
	panAngle = point_direction(x,y-41,relativeMouseX,relativeMouseY);
	
	if keyboard_check(vk_shift) {
		// Round panAngle
		panAngle = round(panAngle/16)*16;
	}
}

// Integer increment buttons
if mouse_check_button_pressed(mb_left) {
	for (i = 0; i <= 2; i += 1) {
		// Offsets
		if i = 0 {
			xOffButtons = 0;
			yOffButtons = 0;
		}
		if i = 1 {
			xOffButtons = 78;
			yOffButtons = 0;
		}
		if i = 2 {
			xOffButtons = 78;
			yOffButtons = 25;
		}
		
		if relativeMouseY >= y - 26 - yOffButtons && relativeMouseY <= y - 20 - yOffButtons {
			if relativeMouseX >= x - 15 + xOffButtons && relativeMouseX <= x - 6 + xOffButtons {
				arrowSelect[0,i] = true;
			}
			if relativeMouseX >= x - 6 + xOffButtons && relativeMouseX <= x + 1 + xOffButtons {
				arrowSelect[1,i] = true;
			}
			if relativeMouseX >= x + 5 + xOffButtons && relativeMouseX <= x + 10 + xOffButtons {
				arrowSelect[2,i] = true;
			}
			if relativeMouseX >= x + 11 + xOffButtons && relativeMouseX <= x + 20 + xOffButtons {
				arrowSelect[3,i] = true;
			}
		}
		if relativeMouseY >= y - 9 - yOffButtons && relativeMouseY <= y - 3 - yOffButtons {
			if relativeMouseX >= x - 15 + xOffButtons && relativeMouseX <= x - 6 + xOffButtons {
				arrowSelect[4,i] = true;
			}
			if relativeMouseX >= x - 6 + xOffButtons && relativeMouseX <= x + 1 + xOffButtons {
				arrowSelect[5,i] = true;
			}
			if relativeMouseX >= x + 5 + xOffButtons && relativeMouseX <= x + 10 + xOffButtons {
				arrowSelect[6,i] = true;
			}
			if relativeMouseX >= x + 11 + xOffButtons && relativeMouseX <= x + 20 + xOffButtons {
				arrowSelect[7,i] = true;
			}
		}
	}
}

// Easing sliders
if mouse_check_button_pressed(mb_left) {
	if relativeMouseX >= x + 22 + (easeOutSliderVal/20)*34 && relativeMouseX <= x + 27 + (easeOutSliderVal/20)*34 {
		// Ease out slider
		if relativeMouseY >= y - 41 && relativeMouseY <= y - 32 {
			sliderSelect[0] = true;
			mouseOff = relativeMouseX - x - 24 - (easeOutSliderVal/20)*34;
		}
	}
	
	if relativeMouseX >= x + 22 + (easeInSliderVal/20)*34 && relativeMouseX <= x + 27 + (easeInSliderVal/20)*34 {	
		// Ease in slider
		if relativeMouseY >= y - 17 && relativeMouseY <= y - 8 {
			sliderSelect[1] = true;
			mouseOff = relativeMouseX - x - 24 - (easeInSliderVal/20)*34;
		}
	}
}

if mouse_check_button(mb_left) {
	// Ease out slider
	if sliderSelect[0] {
		easeOutVal = floor((((relativeMouseX - x - 24 - mouseOff)/34)*20)/2.5)*2.5; // Rounded to nearest multiple of 5
		
		if easeOutVal < 0 {
			easeOutVal = 0;
		}
		if easeOutVal > 20 {
			easeOutVal = 20;
		}
		
		j = 0;
		
		for (i = 0; i <= 3; i += 1) {
			if string_char_at(string_digits(string_digits(easeOutVal)),i+1-j) != "" {
				val[i,2] = real(string_char_at(string_digits(easeOutVal),i+1-j));
			} else {
				val[i,2] = 0;
			}
			easeOutSliderVal = easeOutVal;
			
			if i = 0 {
				if easeOutVal < 10 {
					// Insert a 0 if easeOutVal is not a double-digit integer
					val[0,2] = 0;
					j = 1;
				}
			}
		}
	}
	
	// Ease in slider
	if sliderSelect[1] {
		easeInVal = floor((((relativeMouseX - x - 24 - mouseOff)/34)*20)/2.5)*2.5; // Rounded to nearest multiple of 5
		
		if easeInVal < 0 {
			easeInVal = 0;
		}
		if easeInVal > 20 {
			easeInVal = 20;
		}
		easeInSliderVal = easeInVal;
		
		j = 0;
		
		for (i = 0; i <= 3; i += 1) {
			if string_char_at(string_digits(string_digits(easeInVal)),i+1-j) != "" {
				val[i,1] = real(string_char_at(string_digits(easeInVal),i+1-j));
			} else {
				val[i,1] = 0;
			}
			
			if i = 0 {
				if easeInVal < 10 {
					// Insert a 0 if easeInVal is not a double-digit integer
					val[0,1] = 0;
					j = 1;
				}
			}
		}
	}
}

if easeOutSliderVal > 20 {
	easeOutSliderVal = 20;
}
if easeInSliderVal > 20 {
	easeInSliderVal = 20;
}

// Release buttons
if mouse_check_button_released(mb_left) {
	// Release angle circle
	if mouse_check_button_released(mb_left) {
		selectState = 0;
	}
	
	// Release arrow buttons
	for (j = 0; j <= 2; j += 1) {
		for (i = 0; i <= 7; i += 1) {
			if arrowSelect[i,j] {
				if i <= 3 {
					val[i % 4,j] += 1;
				} else {
					val[i % 4,j] -= 1;
				}
				
				if val[i % 4,j] > 9 {
					val[i % 4,j] = 0;
				}
				if val[i % 4,j] < 0 {
					val[i % 4,j] = 9;
				}
			}
			
			arrowSelect[i,j] = false;
		}
	}
	
	// Release sliders
	sliderSelect[0] = false;
	sliderSelect[1] = false;
}

for (j = 0; j <= 2; j += 1) {
	valPass[j] = real(string(val[0,j])+string(val[1,j])+string(".")+string(val[2,j])+string(val[3,j]));
}

panMagnitude = valPass[0];
easeInVal = valPass[1];
easeOutVal = valPass[2];

gone = true;
