/// @description Change room state for mode
if mode = 1 {
	// Dark grid
	modeGridSpr = spr_grid_dark_editor;
} else {
	// Light grid
	modeGridSpr = spr_grid_editor;
}

// Selecting instances
// Reset state of canSelect each tick
for (i = 0; i < instance_number(obj_editor_placeable_parent); i += 1) {
	with instance_find(obj_editor_placeable_parent,i) {
		canSelect = false;
	}
}

// Selecting and de-selecting instances
if canChangeSelect {
	#region
	
	tempDepth = 0;
	selectInstance = -1;
	
	if window_mouse_get_y() > obj_panel_top.y && !obj_panel_top.canSelect {
		if window_mouse_get_x() > obj_panel_left.x - room_width && !obj_panel_left.canSelect {
			if window_mouse_get_x() < obj_panel_right.x - room_width && !obj_panel_right.canSelect {
				if window_mouse_get_y() < obj_panel_bot.y && !obj_panel_bot.canSelect {
					for (i = 0; i < instance_number(obj_editor_placeable_parent); i += 1) {
						with instance_find(obj_editor_placeable_parent,i) {
							// De-select instance
							select = false;
							
							other.tempSelectInstance = self.id;
						}
						
						if ( tempSelectInstance.object_index != obj_editor_staircase )
						&& (
							(mouseCheckX >= tempSelectInstance.x && mouseCheckX < tempSelectInstance.x + tempSelectInstance.width * 20)
							&& (
								// Typical mouse hovering
								( mouseCheckY >= tempSelectInstance.floorY && mouseCheckY < tempSelectInstance.cielY + tempSelectInstance.height*20  && (mode != 1 && tempSelectInstance.modeForSelect) )
								||
								// Wireframe mouse hovering
								( mouseCheckY >= tempSelectInstance.y + (tempSelectInstance.zfloor- tempSelectInstance.zcieling)*20 && mouseCheckY < tempSelectInstance.y + (tempSelectInstance.height + tempSelectInstance.zfloor - tempSelectInstance.zcieling)*20 && (mode = 1 && tempSelectInstance.modeForSelect) )
							)
						) || ( tempSelectInstance.object_index = obj_editor_staircase && tempSelectInstance.hovered )
						{
							if tempSelectInstance.modeForSelect {
								if tempSelectInstance.depth <= tempDepth {
									tempDepth = tempSelectInstance.depth;
									selectInstance = tempSelectInstance;
								}
							}
						}
					}
					
					if selectInstance != -1 {
						selectInstance.canSelect = true;
					}
				}
			}
		}
	}
	
	#endregion
}

if !instance_exists(obj_editor_placeable_parent) {
	tempSelectInstance = -1;
}

// Spawn collisions
if mode = 2 {
	if !spawnedCollisions {
		#region
		
		spawnedCollisions = true;
		alarm[0] = 2;
		
		with obj_editor_terrain_parent {
			if object_index = obj_editor_staircase {
				// Staircase collision.
				#region
				
				with instance_create_layer(staircaseRasterX0,staircaseRasterY0,"Instances",obj_staircase_collision) {
					width = other.width;
					zfloor = other.zfloor;
					zcieling = other.zcieling;
					angleRun = other.angleRun;
					angleRise = other.angleRise;
					staircaseN = other.staircaseN;
					xStairs = other.x;
					yStairs = other.y;
				
					stairstepRun = staircaseN;
					stairstepRise = (zfloor - zcieling) * 20;
					var largerVal = max(abs(stairstepRun),abs(stairstepRise));
					stairstepRun /= largerVal;
					stairstepRise /= largerVal;
					show_message(string(stairstepRun) + ", " + string(stairstepRise));
				
					image_xscale = ceil((other.staircaseRasterXF - other.staircaseRasterX0) / sprite_width);
					image_yscale = ceil((other.staircaseRasterYF - other.staircaseRasterY0 - other.zfloor*20 + other.zcieling*20) / sprite_height);
					y += (other.zfloor - other.zcieling) * 20;
					depth = other.depth - 100;
				}
				
				#endregion
			} else {
				#region
				
				if zfloor > 0 || !finite {
					with instance_create_layer(x,y,"Instances",obj_solid_mask) {
						if other.collMask = -1 {
							if other.angleSlope = 0 {
								other.collMask = spr_coll_rect;
							} else {
								collKey = string(other.width) + string(other.height) + (other.mirror ? "1" : "0") + (other.flip ? "1" : "0");
								
								if ds_map_exists(obj_editor_gui.collMaskDict,collKey) {
									other.collMask = obj_editor_gui.collMaskDict[?collKey];
								} else {
									show_debug_message(collKey);
									// Bake unique collision mask.
									var collSurf = surface_create(other.width*20, other.height*20);
									draw_set_color(c_black);
									surface_set_target(collSurf);
									
									for (i = 0; i < other.width * 20; i++) {
										for (j = 0; j < other.height * 20; j++) {
											if j <= other.angleStartY - other.angleSlope*i {
												draw_point(i, j);
											}
										}
									}
									
									surface_reset_target();
									other.collMask = sprite_create_from_surface(collSurf, 0, 0, surface_get_width(collSurf), surface_get_height(collSurf), false, false, 0, 0);
									sprite_collision_mask(other.collMask, false, 1, 0, 0, sprite_get_width(other.collMask), sprite_get_height(other.collMask), bboxkind_precise, 0);
									obj_editor_gui.collMaskDict[?collKey] = other.collMask;
									
									surface_free(collSurf);
								}
							}
						}
						
						sprite_index = other.collMask;
						mask_index = other.collMask;
						image_xscale = other.width / (sprite_get_width(sprite_index) / 20);
						y = other.y + other.zfloor*20;
						x = other.x;
						
						zplace = other.zplace;
						zcieling = other.zcieling;
						finite = other.finite;
						
						depth = other.depth - 1;
					}
				}
			
				if finite {
					// Floor collision
					with instance_create_layer(x,y,"Instances",obj_floor) {
						y = other.y;
						x = other.x;
						image_xscale = other.width;
						image_yscale = other.height;
						zfloor = other.zfloor;
						zcieling = other.zcieling;
						depthOffset = other.depthOffset;
						finite = other.finite;
					}
				}
				
				#endregion
			}
		}
		
		#endregion
	}
} else {
	if spawnedCollisions {
		#region
		
		spawnedCollisions = false;
		
		with obj_solid_mask {
			instance_destroy();
		}
		with obj_floor {
			instance_destroy();
		}
		with obj_staircase_collision {
			instance_destroy();
		}
		with obj_trigger_cutscene_region_level {
			instance_destroy();
		}
		with obj_trigger_pan_region_level {
			instance_destroy();
		}
		with obj_trigger_anchor_region_level {
			instance_destroy();
		}
		with obj_player_overworld {
			instance_destroy();
		}
		with obj_npc_position {
			xNode[0] = -1;
			yNode[0] = -1;
			i = 0;
		}
		
		#endregion
	}
}

// Control side panel pushing
if obj_panel_left.select = 0 && obj_panel_right.select = 0 {
	sidePanelCtrl = -1;
}
