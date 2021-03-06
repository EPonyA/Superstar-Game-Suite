/// @description Insert description here
baseY = ( 9 * 20 * obj_editor_gui.realPortScaleVer ) + ( 60 / 576 * obj_editor_gui.calcWindowHeight );
x = room_width + view_wport[1]/2;
relativeX = x - room_width;

canSelect = false;

// Panel dragging behavior
#region

if relativeMouseX - room_width <= relativeX + 60 && relativeMouseX - room_width >= relativeX - 60 {
	if relativeMouseY >= y - 21 && relativeMouseY <= y {
		canSelect = true;
	}
}

if canSelect {
	if mouse_check_button_pressed(mb_left) {
		// Dragging
		select = true;
		tempSubPanelLeftY = obj_subpanel_left.y;
		mouseClickOff = relativeMouseY - y;
		
		// Double clicking
		doubleClickCounter += 1;
		
		image_index = 1;
	}
}

if select {
	if !mouse_check_button(mb_left) {
		select = false;
		
		moveToY = round((relativeMouseY - mouseClickOff + 1) / 10) * 10 + 1;
		
		if moveToY > baseY - 30 && moveToY < baseY + 30 {
			moveToY = baseY;
		}
		if moveToY >= baseY + 30 {
			moveToY = view_hport[1];
		}
		
		if y > moveToY {
			moveDirection = -1;
		} else {
			moveDirection = 1;
		}
		
		moveToSpd = abs(moveToY - y) / 2;
		
		image_index = 0;
	}
	
	// Dragging panel
	dragY = relativeMouseY - mouseClickOff;
	dragYTemp = dragY;
	
	y = dragY;
	
	// Dragging boundary
	if y < 300 {
		y = 300;
	}
	if moveToY < 300 {
		moveToY = 300;
	}
	
	// Preventing displacement of the subpanel
	if !obj_subpanel_left.anchored {
		#region
		
		if y < obj_subpanel_left.y {
			obj_subpanel_left.y = self.y;
		} else {
			obj_subpanel_left.visible = true;
			
			if obj_subpanel_left.mousePeek > 0 {
				obj_subpanel_left.mousePeek -= 3.75;
			} else {
				obj_subpanel_left.mousePeek = 0;
			}
	
			if obj_subpanel_left.y < tempSubPanelLeftY {
				obj_subpanel_left.y = self.y;
			} else {
				obj_subpanel_left.y = tempSubPanelLeftY;
			}
		}
	} else {
		obj_subpanel_left.y = self.y + 5;
		
		#endregion
	}
} else {
	// Double clicking
	alarm[0] = 12;
	
	if doubleClickCounter >= 2 {
		doubleClickCounter = 0;
		
		if floor(y) != floor(baseY) {
			moveToY = baseY;
		} else {
			moveToY = view_hport[1];
		}
		
		moveToSpd = abs(y - baseY) / 7;
		
		// Minimum speed
		if moveToSpd < 13 {
			moveToSpd = 13;
		}
		
		if y > moveToY {
			moveDirection = -1;
		} else {
			moveDirection = 1;
		}
	}
	
	if y != moveToY {
		if abs(moveToY - y) < moveToSpd * 1.8 {
			if moveToSpd > moveToSpdMin {
				moveToSpd /= moveToDeccel;
			} else {
				moveToSpd = moveToSpdMin;
			}
		}
		
		if moveDirection = -1 {
			if y > moveToY + moveToSpd {
				y -= moveToSpd;
			} else {
				y = moveToY;
				moveToSpd = 0;
			}
		} else {
			if y < moveToY - moveToSpd  {
				y += moveToSpd;
			} else {
				y = moveToY;
				moveToSpd = 0;
			}
		}
	}
}

// On base
if floor(y) = floor(baseY) {
	onBase = 1;
} else {
	onBase = 0;
}

// Folded
if y = view_hport[1] {
	onBase = 2;
}

#endregion

// Timeline view
if obj_editor_gui.mode = 4 {
	view_visible[4] = false;
}

// Cutscene editor
if instance_number(obj_npc_level) + 1 != rows {
	rows = instance_number(obj_npc_level) + 1; // Every actor, plus the player character
	rowLength[rows] = 0;
	selectRow[rows] = false;
}

// Adding actions to timeline
if addClick != -1 {
	#region
	
	totalActions += 1;
	actionSelect[totalActions] = false;
	actionDelete[totalActions] = false;
	
	for (i = 0; i < rows; i += 1) {
		if selectRow[i] {
			actionTime[totalActions] = rowLength[i]; // Number of 1/10'th seconds on timeline
			actionRowInd[totalActions] = i; // Which row it's placed on
			
			break;
		}
		
		if i = rows - 1 {
			// Cancel button input if no row is selected
			totalActions -= 1;
		}
	}
	
	if addClick = 0 {
		actionInd[totalActions] = 0; // Walk action
		
		if !instance_exists(obj_cutscene_walk_target) {
			with instance_create_layer(0,0,"Instances",obj_cutscene_walk_target) {
				timeIndex = other.totalActions;
				rowIndex = other.i;
				canPlace = true;
				
				// Fix continuous placements
				if mouse_check_button(mb_left) {
					canRelease = false;
				} else {
					canRelease = true;
				}
				
				with other.actorId[other.i] {
					other.zfloor = self.zfloor;
					other.originX[0] = self.x + 10;
					other.originY[0] = self.y + 10 + zfloor * 20;
				}
			}
		}
	}
	
	if addClick = 1 {
		actionInd[totalActions] = 1; // Rotate action
		
		if !instance_exists(obj_cutscene_rotate_target) {
			with instance_create_layer(0,0,"Instances",obj_cutscene_rotate_target) {
				timeIndex = other.totalActions;
				rowIndex = other.i;
				canPlace = true;
				placed = false;
				calcAngleVals = true;
				angle = 0;
				run = 0;
				rise = 0;
				mirror = 0;
				flip = 0;
				
				// Fix continuous placements
				if mouse_check_button(mb_left) {
					canRelease = false;
				} else {
					canRelease = true;
				}
				
				with other.actorId[other.i] {
					other.zfloor = self.zfloor;
					other.originX[0] = self.x + 10;
					other.originY[0] = self.y + 10;
				}
			}
		}
	}
	
	if addClick = 2 {
		actionInd[totalActions] = 2; // Dialogue action
		
		if !instance_exists(obj_cutscene_dialogue) {
			with instance_create_layer(actorId[i].x+28,actorId[i].y-42,"Instances",obj_cutscene_dialogue) {
				timeIndex = other.totalActions;
				rowIndex = other.i;
				trg = other.actorId[other.i];
				
				placeX = xstart;
				placeY = ystart;
				
				bubbleCount = 0; // 0 is a single bubble
				bubbleX[bubbleCount] = 0;
				bubbleY[bubbleCount] = 0;
				lineCount[bubbleCount] = 0; // 0 is a single line
				lineStr[bubbleCount,0] = "";
				longestLine[bubbleCount] = 0;
				hasText[bubbleCount] = false;
			}
		}
	}
	
	if addClick = 3 {
		actionInd[totalActions] = 3; // Camera pan action
		
		if !instance_exists(obj_cutscene_pan) {
			with instance_create_layer(cutsceneInstanceId.x+10,cutsceneInstanceId.y+10,"Instances",obj_cutscene_pan) {
				timeIndex = other.totalActions;
				trg = other.cutsceneInstanceId;
				zoomVal = "100";
			}
		}
	}
	
	if addClick = 5 {
		actionInd[totalActions] = 5; // Walk speed action
		
		if !instance_exists(obj_cutscene_speed) {
			with instance_create_layer(actorId[i].x+10,actorId[i].y-35,"Instances",obj_cutscene_speed) {
				timeIndex = other.totalActions;
				rowIndex = other.i;
				canPlace = true;
				
				trg = other.cutsceneInstanceId;
				zfloor = trg.zfloor;
				
				slowSpd = true; // Default to slow speed
			}
		}
	}
	
	if addClick = 6 {
		actionInd[totalActions] = 6; // Arbitrary action
		
		if !instance_exists(obj_cutscene_arbitrary) {
			with instance_create_layer(actorId[i].x+10,actorId[i].y-35,"Instances",obj_cutscene_arbitrary) {
				timeIndex = other.totalActions;
				rowIndex = other.i;
				
				trg = other.cutsceneInstanceId;
				zfloor = trg.zfloor;
				
				arbitraryInd = 0;
				selected = false;
			}
		}
	}
	
	addClick = -1;
	
	#endregion
}

// Selecting / De-selecting rows
for (i = 0; i < rows; i += 1) {
	#region
	
	// Initialize actorId[]'s
	// TODO: Does not need to be updated every tick.
	#region
	
	if i = 0 {
		if instance_exists(obj_trigger_region_parent) {
			with selectedRegionID  {
				other.actorId[0] = self.id;
			}
		}
	} else {
		actorId[i] = instance_find(obj_npc_editor, i - 1);
		actorRowTxt[i] = actorId[i].actorTxt;
	}
	
	#endregion
	
	// Hover over row
	canSelectRow[i] = (
		(relativeMouseX - room_width >= 21 && relativeMouseX <= obj_panel_left.baseX - 1)
		&& (relativeMouseY >= y+35 + (rows-1)*14 - rowsDrawY && relativeMouseY <= y+46 + (rows-1)*14 - rowsDrawY )
	);
	
	// Toggle this row's selection.
	if (relativeMouseX - room_width >= 21 && relativeMouseX <= obj_panel_left.baseX - 1
	&& relativeMouseY >= y+35 && relativeMouseY <= view_hport[1]
	) {
		if mouse_check_button_pressed(mb_left) {
			selectRow[i] = canSelectRow[i] && !selectRow[i];
		}
	}
	
	actorId[i].orangeAnyways = selectRow[i];
	
	// True if any row has been selected.
	hasRowSelected = max(hasRowSelected, selectRow[i]);
	
	// Select row once 
	#region
	
	if mouse_check_button_pressed(mb_left)  && selectRow[i] 
	{	
		if !instance_exists(obj_trigger_widget_parent) 
		&& !instance_exists(obj_editor_button_parent)
		{
			actorId[i].spawnButtons  = actorId[i].select;
		}
		
		if instance_exists(obj_cutscene_actor_dummy_player) {
			if instance_exists(obj_npc_level) {
				if i == 0 {
					obj_cutscene_actor_dummy_player.depthPriority = true;
					obj_npc_level.depthPriority = false;
				} else {
					obj_cutscene_actor_dummy_player.depthPriority = false;
					
					with actorId[i] {
						trg.depthPriority = true;
					}
				}
			}
		}
	}
	
	#endregion
		
	#endregion
}

// Calculating length of timeline
#region

longestRowLength = 0;

if totalActions > 0 {
	for (i = 0; i <= rows; i += 1) {
		rowLength[i] = 0;
		
		for (j = 1; j <= totalActions; j += 1) {
			if actionRowInd[j] = i {
				if actionInd[j] != -1 {
					// Length of each row
					if actionTime[j] + 1 > rowLength[i] {
						rowLength[i] = actionTime[j] + 1;
					}
					
					// Longest row
					if rowLength[i] > longestRowLength {
						longestRowLength = rowLength[i];
					}
				}
			}
		}
	}
}

#endregion

panelWidth = longestRowLength*6 + 2;
panelHeight = (rows) * 14;

// Minimum length
if panelWidth < view_wport[1] - (obj_panel_right.baseX - obj_panel_left.baseX + 2) {
	panelWidth = view_wport[1] - (obj_panel_right.baseX - obj_panel_left.baseX + 2);
}

// Drag actions
cameraNetX = camera_get_view_x(obj_editor_gui.cameraBotPanel) - (camera_get_view_x(obj_editor_gui.cameraLeftSubPanel) ) - panelOffset;
potentialActionTime = floor( (relativeMouseX - room_width - (obj_panel_left.baseX - room_width + 1) + cameraNetX) / 6);

ax = ( ((scrollHorX - ( obj_panel_left.baseX + 1 - room_width ) - room_width ) / (scrollHorRightBound - scrollHorLeftBound)) * panelWidth ) + 1;

// Edit action
if obj_editor_gui.mode = 4 {
	#region
	
	for (i = 1; i <= totalActions; i += 1) {
		for (j = 0; j < rows; j += 1) {
			if y + 33 - rowsDrawY + i*14 > scrollHorBotBound {
				if relativeMouseX - room_width > (obj_panel_left.baseX - room_width + 2) - ax + actionTime[i]*6 && relativeMouseX - room_width <= (obj_panel_left.baseX - room_width + 1) - ax + actionTime[i]*6 + 6 {
					if relativeMouseY >= y + 34 + j*14 - rowsDrawY && relativeMouseY <= y + 44 + j*14 - rowsDrawY {
						if relativeMouseX - room_width >= obj_panel_left.baseX - room_width {
							if actionInd[i] != -1 {
								if actionRowInd[i] = j {
									// Open action's interface
									if mouse_check_button_pressed(mb_left) {
										#region
										
										actionSelect[i] = true;
										actorId[j].orangeAnyways = true;
										
										for ( var jj = 0; jj < rows; jj += 1) {
											selectRow[jj] = false;
										}
										
										selectRow[j] = true;
										
										actionDoubleClick += 1;
										alarm[1] = 12;
										
										if actionDoubleClick = 2 {
											actionDoubleClick = 0;
											
											// Walk action
											if actionInd[i] = 0 {
												#region
												
												if !instance_exists(obj_cutscene_walk_target) {
													with instance_create_layer(xNode[i],yNode[i],"Instances",obj_cutscene_walk_target) {
														timeIndex = other.i
														rowIndex = other.j;
														canDrag = true;
														canPlace = false;
												
														with other.actorId[other.j] {
															other.zfloor = self.zfloor;
															other.originX[0] = self.x + 10;
															other.originY[0] = self.y + 10 + zfloor*20;
														}
													}
												}
												
												#endregion
											}
											
											// Rotate action
											if actionInd[i] = 1 {
												#region
												
												if !instance_exists(obj_cutscene_rotate_target) {
													with instance_create_layer(actorId[j].x+10,actorId[j].y+10,"Instances",obj_cutscene_rotate_target) {
														timeIndex = other.i;
														rowIndex = other.j;
														canDrag = true;
														canPlace = false;
														canDel = true;
														calcAngleVals = true;
														angle = other.angleRot[other.i];
														
														with other.actorId[other.j] {
															other.zfloor = self.zfloor;
															other.originX[0] = self.x+10;
															other.originY[0] = self.y+10;
														}
													}
												}
												
												#endregion
											}
											
											// Dialogue action
											if actionInd[i] = 2 {
												#region
												
												if !instance_exists(obj_cutscene_dialogue) {
													with instance_create_layer(actorId[j].x-xOffDialogue[i],actorId[j].y-yOffDialogue[i],"Instances",obj_cutscene_dialogue) {
														timeIndex = other.i;
														rowIndex = other.j;
														trg = other.actorId[other.j];
														zfloor = trg.zfloor;
														placex = xstart;
														placey = ystart;
														
														bubbleCount = other.bubbleCount[other.i];
														
														for (i = 0; i <= bubbleCount; i += 1) {
															lineCount[i] = other.lineCount[other.i,i];
															longestLine[i] = 0; // This value is arbitrary
															bubbleX[i] = other.bubbleX[other.i,i];
															bubbleY[i] = other.bubbleY[other.i,i];
															
															for (j = 0; j <= 3; j += 1) {
																selectBubSlider[i,j] = false;
																sliderMagnitude[i,j] = 0;
															}
															
															for (j = 0; j <= lineCount[i]; j += 1) {
																lineStr[i,j] = other.lineStr[scr_array_xy(i,j,bubbleCount),j];
															}
															
															if lineCount[i] = 0 && lineStr[i,0] = "" {
																hasText[i] = false;
															} else {
																hasText[i] = true;
															}
														}
													}
												}
												
												#endregion
											}
											
											// Camera pan action
											if actionInd[i] = 3 {
												#region
												
												if !instance_exists(obj_cutscene_pan) {
													with instance_create_layer(xNode[i],yNode[i],"Instances",obj_cutscene_pan) {
														timeIndex = other.i;
														trg = other.cutsceneInstanceId;
														zoomVal = string(other.zoomVal[timeIndex]);
													}
												}
												
												#endregion
											}
											
											// Actor speed action
											if actionInd[i] = 5 {
												#region
												
												with instance_create_layer(actorId[j].x+10,actorId[j].y-35,"Instances",obj_cutscene_speed) {
													timeIndex = other.i;
													slowSpd = other.slowSpd[timeIndex];
													
													trg = other.cutsceneInstanceId;
													zfloor = trg.zfloor;
												}
												
												#endregion
											}
											
											// Arbitrary action
											if actionInd[i] = 6 {
												#region
												
												with instance_create_layer(actorId[j].x+10,actorId[j].y-35,"Instances",obj_cutscene_arbitrary) {
													timeIndex = other.i;
													arbitraryInd = other.arbitraryInd[timeIndex];
													
													trg = other.cutsceneInstanceId;
													zfloor = trg.zfloor;
													
													selected = true;
												}
											}
											
											#endregion
										}
										
										#endregion
									}
									
									if mouse_check_button(mb_right) {
										actionDelete[i] = true;
									}
								}
							}
						}
					} else {
						if actionRowInd[i] = j {
							actionDelete[i] = false;
						}
					}
				} else {
					actionDelete[i] = false;
				}
				
				// Dragging actions
				if actionSelect[i] {
					#region
					
					actionTimeTemp = actionTime[i];
					
					for (a = 1; a <= totalActions; a += 1) {
						if actionRowInd[a] = actionRowInd[i] {
							if actionInd[a] != -1 {
								if actionTime[a] = potentialActionTime {
									actionTime[i] = actionTimeTemp; // Prevent the actions from overlapping
									
									break;
								}
							}
						}
						
						if a = totalActions {
							actionTime[i] = potentialActionTime; // Drag action snapped to 1/5 second ticks
							
							if actionTime[i] < 0 {
								for (b = 1; b <= totalActions; b += 1) {
									if actionTime[b] = 0 {
										actionTime[i] = actionTimeTemp; // Dragging boundary
										
										break;
									}
									
									if b = totalActions {
										actionTime[i] = 0;
									}
								}
							}
						}
					}
					
					#endregion
				}
				
				if actionDelete[i] {
					// Delete the action
					if mouse_check_button_released(mb_right) {
						if actionDelete[i] {
							actionInd[i] = -1; // Null action
						}
					}
				}
				
				if mouse_check_button_released(mb_left) {
					actionSelect[i] = false; // De-select
				}
			}
		}
	}
	
	#endregion
}

// Target cutscene
if cutsceneInstanceId != -1 {
	if instance_exists(cutsceneInstanceId) {
		if obj_editor_gui.mode = 4 {
			if !cutsceneInstanceId.select {
				event_user(0); // Export currently selected event.
				
				totalActions = 0;
				cutsceneInstanceId = -1; // Reset target instance
			}
		}
	} else {
		// Clear interface when trigger instance is deleted while selected
		cutsceneInstanceId = -1;
	}
}

// End scenes interrupted by a mode change
if isPlayingScene {
	if obj_editor_gui.mode != 2 {
		isPlayingScene = false;
		cutsceneInstanceId = -1;
	}
}

// Clear the cutscene interface
if !isPlayingScene {
	if cutsceneInstanceId = -1 {
		for (i = 0; i <= self.rows; i += 1) {
			rowLength[i] = 0;
		}
		for (j = 1; j <= self.totalActions; j += 1) {
			actionInd[j] = -1;
		}
	}
}

// Views
#region

// Prevent left sub-panel buttons from ever clipping into the bottom panel
panelOffset = obj_subpanel_left.longestSprWidth

if panelOffset < obj_subpanel_left.panelWidth {
	panelOffset = obj_subpanel_left.panelWidth;
}

if updateView {
	view_xport[4] = obj_panel_left.baseX - room_width + 1;
	view_yport[4] = y + 34;
	view_wport[4] = view_wport[1] - ( ( obj_panel_left.baseX - room_width ) * 2 );
	view_hport[4] = view_hport[1] - y - 37;
	
	view_xport[6] = 17;
	view_yport[6] = view_yport[4];
	view_wport[6] = obj_panel_left.baseX - room_width - 17;
	view_hport[6] = view_hport[4];
	
	camera_set_view_pos(obj_editor_gui.cameraBotPanel,camera_get_view_x(obj_editor_gui.cameraLeftSubPanel) + panelOffset  + ( ((scrollHorX - (obj_panel_left.baseX - room_width + 1) - room_width) / (scrollHorRightBound - scrollHorLeftBound)) * panelWidth),0);
	camera_set_view_size(obj_editor_gui.cameraBotPanel,view_wport[4],view_hport[4]);
	
	camera_set_view_pos(obj_editor_gui.cameraBotPanelActors,camera_get_view_x(obj_editor_gui.cameraBotPanel) + view_wport[4],camera_get_view_y(obj_editor_gui.cameraBotPanel) );
	camera_set_view_size(obj_editor_gui.cameraBotPanelActors,view_wport[6],view_hport[6]);
	
	if y >= view_hport[1] {
		y = view_hport[1];
		view_visible[4] = false;
	} else {
		view_visible[4] = true;
	}
	
	if !visible {
		view_set_visible(4,false);
	}
	
	view_visible[6] = view_visible[4];
	
	// Minimap
	#region
	
	// Keep width proportional to the height, or vice versa, depending on which is larger
	if room_width >= room_height {
		mapRatio = room_height / room_width;
		
		mapWidth = (room_width + view_wport[1] - 37) - (obj_panel_right.baseX + 34);
		mapHeight = mapWidth * mapRatio;
	} else {
		mapRatio = room_width / room_height;
		
		mapHeight = (view_hport[1] - 26) - (baseY + 5);
		mapWidth = mapHeight * mapRatio;
	}
	
	// Map size limits
	if mapHeight > (view_hport[1] - 26) - (baseY + 5) {
		mapHeight =  (view_hport[1] - 26) - (baseY + 5);
		mapWidth = mapHeight * mapRatio;
	}
	
	if mapWidth != tempMapWidth && mapHeight != tempMapHeight {
		tempMapWidth = mapWidth;
		tempMapHeight = mapHeight;
		
		if surface_exists(mapSurface) {
			surface_resize(mapSurface,mapWidth,mapHeight);
		}
	}
	
	// Make map drag with the bottom panel
	if y > baseY {
		mapFoldOff = floor( (y - baseY) / 2 );
	} else {
		mapFoldOff = 0;
	}
	
	mapCenterX = floor( room_width + (view_wport[1]) - (room_width + (view_wport[1]) - obj_panel_right.baseX) / 2 );
	mapCenterY = floor( y + 5 + ( (view_hport[1] - 26) - (y + 5) ) / 2 ) + mapFoldOff;
	
	// 16:9 ratio cursor
	mapCursorWidth = (320) * (mapWidth - 10) / ( (room_width) );
	mapCursorHeight = mapCursorWidth * 9/16;
	
	// Conversion ratios: Room units to map units
	mapCursorIncrementX = (mapWidth - 12) / ( (room_width - 320) / 20 ) - ( mapCursorWidth / ( (room_width - 320) / 20 ));
	mapCursorIncrementY = (mapHeight - 12) / ( (room_height - 180) / 20 )  - ( mapCursorHeight /  ( (room_height - 180) / 20 ));
	
	// Click on the map
	if mouse_check_button_pressed(mb_left) {
		if relativeMouseX >= mapCenterX - floor((mapWidth-10)/2) && relativeMouseX <= mapCenterX + floor((mapWidth-10)/2) {
			if relativeMouseY >= mapCenterY - floor((mapHeight-10)/2) && relativeMouseY <= mapCenterY + floor((mapHeight-10)/2) {
				mapSelect = true;
			}
		}
	}
	
	// Release map
	if !mouse_check_button(mb_left) {
		mapSelect = false;
	}
	
	if mapSelect {
		obj_camera_editor.gridAtX = round( ( (relativeMouseX - (mapCenterX - floor((mapWidth-10)/2)) ) * room_width/mapWidth ) / 20 )
		obj_camera_editor.gridAtY = round( ( (relativeMouseY - (mapCenterY - floor((mapHeight-10)/2)) ) * room_height/mapHeight ) / 20 )
		
		// Limits
		if obj_camera_editor.gridAtX > room_width div 20 - 16 {
			obj_camera_editor.gridAtX = room_width div 20 - 16;
		}
		if obj_camera_editor.gridAtX < 0 {
			obj_camera_editor.gridAtX = 0;
		}
		if obj_camera_editor.gridAtY > room_height div 20 - 9 {
			obj_camera_editor.gridAtY = room_height div 20 - 9;
		}
		if obj_camera_editor.gridAtY < 0 {
			obj_camera_editor.gridAtY = 0;
		}
		
		obj_camera_editor.curAtX = obj_camera_editor.gridAtX;
		obj_camera_editor.curAtY = obj_camera_editor.gridAtY;
	}
	
	// Increment the cursor
	mapCursorX = obj_camera_editor.gridAtX * mapCursorIncrementX;
	mapCursorY = obj_camera_editor.gridAtY * mapCursorIncrementY;
	
	#endregion
}

#endregion

// Scroll bars
#region

scrollHorLeftBound = obj_panel_left.baseX;
scrollHorRightBound = obj_panel_right.baseX
scrollHorTopBound = y+4;
scrollHorBotBound = y+19;

scrollVerLeftBound = room_width;
scrollVerRightBound = room_width + 16;
scrollVerTopBound = y+34;
scrollVerBotBound = view_hport[1] - 1;
botPanelY = scrollVerBotBound - scrollVerTopBound;

scrollRegionX1 = scrollVerLeftBound;
scrollRegionX2 = scrollHorRightBound;
scrollRegionY1 = scrollVerTopBound;
scrollRegionY2 = scrollVerBotBound;

#endregion

event_inherited();

actorDrawX = camera_get_view_x(obj_editor_gui.cameraBotPanelActors);
rowsDrawY = ( panelHeight - (scrollVerBotBound - scrollVerTopBound)) * scrollVerPartition / 100;
