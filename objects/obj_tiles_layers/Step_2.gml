/// @description 
event_inherited();

// Hover mouse over new layer buttons
plusCol = graphicCol1;
dieCol = graphicCol1;

if mouse_y >= y + 11 + (tileLayerCount + 2) * 11 && mouse_y <= y + 11 + (tileLayerCount + 3) * 11 {
	#region
	
	if mouse_x >= x + 28 && mouse_x <= x + 34 {
		plusCol = insideCol;
	}
	
	if mouse_x >= x + 37 && mouse_x <= x + 45 {
		dieCol = insideCol;
		
		// Prevent duplicate marble layers
		for (i = 0; i <= tileLayerCount; i += 2) {
			if layerType[i] = 1 {
				// Re-calculate pre-existant marble layer
				if mouse_check_button_pressed(mb_left) {
					trgId.genMarble = true;
					
					exit;
				}
			}
		}
	}
	
	#endregion
}

// Initialize a new tile layer
if mouse_check_button_pressed(mb_left) {
	if plusCol = insideCol || dieCol = insideCol {
		#region
		
		passIn = true;
		
		tileLayerCount += 2;
		trgId.tileLayerCount = self.tileLayerCount;
		obj_tiles_grid.tileLayerCount = self.tileLayerCount;
		
		// Absolute order
		layerOrder[tileLayerCount] = tileLayerCount;
		trgId.layerOrder[tileLayerCount] = tileLayerCount;
		obj_tiles_grid.layerOrder[tileLayerCount] = self.tileLayerCount;
		
		// Relative layer values
		
		// Tile layer
		if plusCol = insideCol {
			layerType[tileLayerCount] = 0;
			trgId.layerType[tileLayerCount] = 0;
		}
		
		// Marble layer
		if dieCol = insideCol {
			layerType[tileLayerCount] = 1;
			trgId.layerType[tileLayerCount] = 1;
			
			trgId.genMarble = true;
		}
		
		obj_tiles_grid.layerType[tileLayerCount] = self.layerType[tileLayerCount];
		obj_tiles_grid.layerTypeAbsolute[tileLayerCount] = self.layerType[tileLayerCount];
		
		layerAlpha[tileLayerCount] = 1;
		
		layerVisible[tileLayerCount] = true;
		trgId.layerVisible[tileLayerCount] = true;
		obj_tiles_grid.layerVisible[tileLayerCount] = true;
		obj_tiles_grid.layerVisibleAbsolute[tileLayerCount] = true;
		
		for (k = 0; k <= tileLayerCount; k += 1) {
			// De-selectLayer all layers
			selectLayer[k] = false;
		}
		
		// selectLayer new layer
		obj_tiles_grid.tileLayerSelect = tileLayerCount;
		
		selectLayer[tileLayerCount] = true;
		canSelectLayer[tileLayerCount] = true;
		selectLayer[tileLayerCount+1] = false;
		canSelectLayer[tileLayerCount+1] = false;
		
		eyeState[tileLayerCount] = 0;
		eyeCol[tileLayerCount] = graphicCol1;
		
		layerName[tileLayerCount] = "layer_" + string(tileLayerCount div 2);
		trgId.layerName[tileLayerCount] = self.layerName[tileLayerCount];
		layerName[tileLayerCount+1] = "sublayer_" + string(tileLayerCount div 2);
		trgId.layerName[tileLayerCount+1] = self.layerName[tileLayerCount+1];
		
		// Initialize new tiles
		for (i = 0; i < trgId.tilingWidth; i++) {
			for (j = 0; j < trgId.tilingHeight; j++) {
				// Tiles layer
				if layerType[tileLayerCount] = 0 {
					trgId.hasTile[ scr_array_xy( i,j,trgId.tileArrayHeight ), tileLayerCount ] = false;
					trgId.hasTile[ scr_array_xy( i,j,trgId.tileArrayHeight ), tileLayerCount + 1 ] = false;
					
					with obj_tiles_grid {
						if i = other.i && j = other.j {
							hasTile[other.tileLayerCount] = false;
							hasTile[other.tileLayerCount + 1] = false;
						}
					}
				}
				
				// Marble layer
				if layerType[tileLayerCount] = 1 {
					if i = 0 || i >= trgId.width + 1 || j = 0 {
						// Perimeter is empty
						trgId.hasTile[ scr_array_xy( i,j,trgId.tileArrayHeight ), tileLayerCount ] = false;
						
						with obj_tiles_grid {
							if i = other.i && j = other.j {
								hasTile[other.tileLayerCount] = false;
							}
						}
					} else {
						// Center is filled with marble
						trgId.hasTile[ scr_array_xy( i,j,trgId.tileArrayHeight ), tileLayerCount ] = true;
						
						with obj_tiles_grid {
							if i = other.i && j = other.j {
								hasTile[other.tileLayerCount] = true;
							}
						}
					}
					
					// Clear sublayers
					trgId.hasTile[ scr_array_xy( i,j,trgId.tileArrayHeight ), tileLayerCount + 1 ] = false;
					obj_tiles_grid.hasTile[ scr_array_xy( i,j,trgId.tileArrayHeight ), tileLayerCount + 1] = false;
				}
			}
		}
		
		obj_tiles_grid.hasTileAbsolute[tileLayerCount] = false;
		obj_tiles_grid.hasTileAbsolute[tileLayerCount+1] = false;
		
		exit;
		
		#endregion
	}
}

// Update the sub-panel height
obj_subpanel_left.panelHeight = (tileLayerCount + 2) * 11 + 33;

// Manipulate layers
for (i = 0; i <= tileLayerCount; i += 2) {
	canSelectLayer[i] = false;
	
	// Toggle layer eye
	eyeCol[i] = graphicCol1;
	
	if mouse_x >= x + 18 && mouse_x <= x + 27 && mouse_y >= y + 11 + 2 + layerOrder[i] * 11 && mouse_y < y + 11 + 12 + layerOrder[i] * 11 {
		#region
		
		eyeCol[i] = insideCol;
		
		if mouse_check_button_pressed(mb_left) {
			if eyeState[i] = 0 {
				eyeState[i] = 1;
				layerAlpha[i] = 0.5;
				trgId.layerVisible[i] = false;
				
				obj_tiles_grid.layerVisible[i] = false;
			} else {
				eyeState[i] = 0;
				layerAlpha[i] = 1;
				trgId.layerVisible[i] = true;
				
				obj_tiles_grid.layerVisible[i] = true;
			}
			
			// Recalculating a marble surface lost after
			// resizing the game window when invisible
			if layerType[i] = 1 { // Marble layer
				if layerVisible[i] {
					if trgId.marbleLostResize {
						trgId.bakeMarble = true;
						trgId.marbleLostResize = false;
					}
				}
			}
			
			passIn = true;
		}
		
		#endregion
	}
	
	if !draggingMouseInit {
		// selectLayer layer
		if mouse_x >= x + 30 && ( mouse_x <= x + 36 + string_width(layerName[i]) || (mouse_x <= x + 75 && layerName[i] = "") ) && mouse_y >= y + 11 + 2 + layerOrder[i] * 11 && mouse_y < y + 11 + 12 + layerOrder[i] * 11 {
			canSelectLayer[i] = true;
			
			if mouse_check_button_pressed(mb_left) {
				if selectLayer[i] {
					selectLayer[i] = false;
					obj_tiles_grid.tileLayerSelect = -1;
				} else {
					for (k = 0; k <= tileLayerCount + 1; k += 1) {
						// De-selectLayer all other layers
						selectLayer[k] = false;
					}
					
					selectLayer[i] = true;
					obj_tiles_grid.tileLayerSelect = i;
					
					tempMouseX = window_mouse_get_x();
					tempMouseY = window_mouse_get_y();
					mouseOffY = y + 1 + layerOrder[i] * 11 - mouse_y;
				}
				
				dragLayer = i;
				tempOrder = layerOrder[i];
				draggingMouseInit = true;
				
				break;
			}
		} else {
			// De-selectLayer layer
			if !(window_mouse_get_x() < obj_panel_left.x - room_width && window_mouse_get_y() < obj_subpanel_left.y + 11) {
				if !(window_mouse_get_x() > obj_panel_right.x - room_width && window_mouse_get_y() < obj_panel_bot.y + 11) {
					if mouse_check_button_pressed(mb_left) {
						selectLayer[i] = false;
						obj_tiles_grid.tileLayerSelect = -1;
					}
				}
			}
		}
		
		// Name
		if selectLayer[i] {
			if keyboard_check_pressed(vk_anykey) {
				layerName[i] = typeText(layerName[i], true);
				passIn = true;
			}
			
			trgId.layerName[i] = self.layerName[i];
		}
		
		// Sub-layers
		canSelectLayer[i+1] = false;
		
		// selectLayer sub-layer
		if mouse_x >= x + 34 && ( mouse_x <= x + 44 + string_width(layerName[i+1]) || (mouse_x <= x + 85 && layerName[i+1] = "") ) && mouse_y >= y + 11 + 2 + (layerOrder[i] + 1) * 11 && mouse_y < y + 11 + 12 + (layerOrder[i] + 1) * 11 {
			canSelectLayer[i+1] = true;
			
			if mouse_check_button_pressed(mb_left) {
				if selectLayer[i+1] {
					selectLayer[i+1] = false;
					obj_tiles_grid.tileLayerSelect = -1;
				} else {
					for (k = 0; k <= tileLayerCount + 1; k += 1) {
						// De-selectLayer all other layers
						selectLayer[k] = false;
					}
					
					selectLayer[i+1] = true;
					obj_tiles_grid.tileLayerSelect = i + 1;
				}
				
				break;
			}
		} else {
			// De-selectLayer sub-layer
			if !(window_mouse_get_x() < obj_panel_left.x - room_width && window_mouse_get_y() < obj_subpanel_left.y + 11) {
				if !(window_mouse_get_x() > obj_panel_right.x - room_width && window_mouse_get_y() < obj_panel_bot.y + 11) {
					if mouse_check_button_pressed(mb_left) {
						selectLayer[i+1] = false;
						obj_tiles_grid.tileLayerSelect = -1;
					}
				}
			}
		}
		
		// Name sub-layer
		if selectLayer[i+1] {
			if keyboard_check_pressed(vk_anykey) {
				layerName[i+1] = typeText(layerName[i+1], true);
				passIn = true;
			}
			
			trgId.layerName[i+1] = self.layerName[i+1];
		}
	}
}

// Dragging layers
if (point_distance(window_mouse_get_x(),window_mouse_get_y(),tempMouseX,tempMouseY) > 6 && draggingMouseInit) || draggingMouse {
	draggingMouse = true;
	selectLayer[dragLayer] = true;
	layerAlpha[dragLayer] = 0.5;
	
	layerOrder[dragLayer] = (window_mouse_get_y() - obj_subpanel_left.y - y + 1 + mouseOffY) / 11;
	
	// Snapping layer to position
	if layerOrder[dragLayer] < tempOrder - 2 + 0.35 {
		layerOrder[dragLayer] = tempOrder - 2;
	} else if layerOrder[dragLayer] > tempOrder + 2 - 0.35 {
		layerOrder[dragLayer] = tempOrder + 2;
	} else if layerOrder[dragLayer] < tempOrder + 0.35 && layerOrder[dragLayer] > tempOrder - 0.35 {
		layerOrder[dragLayer] = tempOrder;
	}
	
	// Layer boundaries; clamp() wasn't working for some reason
	if layerOrder[dragLayer] < 0 { layerOrder[dragLayer] = 0; }
	if layerOrder[dragLayer] > tileLayerCount { layerOrder[dragLayer] = tileLayerCount; }
	
	// Shift displaced layers
	for (i = 0; i <= tileLayerCount; i += 2) {
		if i != dragLayer {
			if layerOrder[dragLayer] = layerOrder[i] {
				if tempOrder < layerOrder[i] {
					layerOrder[i] -= 2;
				}
				
				if tempOrder > layerOrder[i] {
					layerOrder[i] += 2;
				}
				
				tempOrder = layerOrder[dragLayer];
				passIn = true;
			}
		}
	}
	
	// Release dragging layer
	if !mouse_check_button(mb_left) {
		draggingMouse = false;
		selectLayer[dragLayer] = false;
		
		layerOrder[dragLayer] = tempOrder;
		
		if eyeState[dragLayer] = 0 {
			layerAlpha[dragLayer] = 1;
		}
	}
}

// Don't prepare to drag layer when merely selecting
if !draggingMouse {
	if !mouse_check_button(mb_left) {
		draggingMouseInit = false;
		dragLayer = -1;
	}
}

// select resource name
if mouse_x >= x + 2 && mouse_x <= x + 1 + string_width(tileDefaultSpr) && mouse_y >= y && mouse_y <= y + 11 - 2 {
	resourceCanSelect = true;
} else {
	resourceCanSelect = false;
}

if mouse_check_button_pressed(mb_left) {
	if resourceCanSelect {
		resourceSelect = !resourceSelect;
	} else {
		resourceSelect = false;
	}
}

if resourceSelect {
	if keyboard_check_pressed(vk_anykey) {
		tileDefaultSpr = typeText(tileDefaultSpr, true);
		
		// Pass in tileset resource
		if asset_get_index(tileDefaultSpr) != -1 {
			trgId.tileDefaultSpr = tileDefaultSpr;
			trgId.tileDrawSpr = asset_get_index(tileDefaultSpr);
			obj_tiles_grid.tileDrawSpr = asset_get_index(tileDefaultSpr);
			obj_tiles_sheet.tileDefaultSpr = asset_get_index(tileDefaultSpr);
		}
	}
}

// Pass in layer order into obj_tiles_grid
if passIn {
	passIn = false;
	
	for (i = 0; i <= tileLayerCount; i += 2) { // Arbitrary
		obj_tiles_grid.layerOrder[i] = self.layerOrder[i];
		trgId.layerOrder[i] = self.layerOrder[i];
	}
	
	// obj_tiles_grid passes layer values into terrain instances
	obj_tiles_grid.passIn = true;
}
