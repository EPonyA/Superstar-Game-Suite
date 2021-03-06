/// @description Manipulating dimensions
event_inherited();

// Make z-dimension flat
zcieling = zfloor;

// Initially generate a 1x1 square polygon region
if placed = 1 {
	#region
	
	with instance_create_layer(x,y,"Instances",obj_trigger_vertex) {
		other.vertexInstanceId[self.vertexInd] = self.id;
		self.trg = other.id;
		self.vertexToInd = instance_number(obj_trigger_vertex) + 2;
		trgXOff = x - other.x;
		trgYOff = y - other.y ;
	}
	with instance_create_layer(x+20,y,"Instances",obj_trigger_vertex) {
		other.vertexInstanceId[self.vertexInd] = self.id;
		self.trg = other.id;
		self.vertexToInd = instance_number(obj_trigger_vertex) - 1;
		trgXOff = x - other.x;
		trgYOff = y - other.y ;
	}
	with instance_create_layer(x,y+20,"Instances",obj_trigger_vertex) {
		other.vertexInstanceId[self.vertexInd] = self.id;
		self.trg = other.id;
		self.vertexToInd = instance_number(obj_trigger_vertex) + 1;
		trgXOff = x - other.x;
		trgYOff = y - other.y ;
	}
	with instance_create_layer(x+20,y+20,"Instances",obj_trigger_vertex) {
		other.vertexInstanceId[self.vertexInd] = self.id;
		self.trg = other.id;
		self.vertexToInd = instance_number(obj_trigger_vertex) - 2;
		trgXOff = x - other.x;
		trgYOff = y - other.y ;
	}
	
	recalculate = true;
	placed = 2;
	
	#endregion
}

// Dimensional manipulation
if spawnButtons {
	#region
	
	spawnButtons = false;
	
	if width = 1 {
		// Revert size
		width = widthTemp;
	}
	
	with instance_create_layer(x,y,"Instances",obj_arrow_editor_drag) {
		trg = other.id;
	}
	with instance_create_layer(x+width*10,y+height*10,"Instances",obj_arrow_editor_z3) {
		trg = other.id;
	}
	with instance_create_layer(x,y+20,"Instances",obj_x_editor) {
		trg = other.id;
	}
	
	with obj_trigger_vertex {
		if trg = other.id {
			alarm[0] = 2;
		}
	}
	
	// Fix issues when the sub-panel is folded
	if obj_subpanel_left.y >= obj_panel_bot.y {
		obj_subpanel_left.tempY = -1;
	}
	
	#endregion
}

// Trigger manipulation
if spawnTriggers {
	#region
	
	spawnTriggers = false;
	
	with instance_create_layer(x,y,"Instances",obj_region_button_vertex) {
		sortIndex = 0;
		viewOn = 5;
		panelId = obj_subpanel_left.id;
		trg = other.id;
		sprWidth = (string_width(label) + 5) * 2;
	}
	with instance_create_layer(x,y,"Instances",obj_region_button_edge) {
		sortIndex = 1;
		viewOn = 5;
		panelId = obj_subpanel_left.id;
		trg = other.id;
		sprWidth = (string_width(label) + 5) * 2;
	}
	with instance_create_layer(x,y,"Instances",obj_region_button_threshold) {
		sortIndex = 2;
		viewOn = 5;
		panelId = obj_subpanel_left.id;
		trg = other.id;
		sprWidth = (string_width(label) + 5) * 2;
	}
	with instance_create_layer(x,y,"Instances",obj_panel_button_wheel) {
		label = "Angle";
		
		sortIndex = 3;
		buttonType = 1;
		viewOn = 5;
		panelId = obj_subpanel_left.id;
		angle = other.angle;
		trg = other.id;
		sprWidth = (string_width(label) + 5) * 2;
		
		other.angleId = self.id;
	}
	with instance_create_layer(x,y,"Instances",obj_panel_buton_input_num) {
		label = "Magnitude";
		
		sortIndex = 4;
		viewOn = 5;
		panelId = obj_subpanel_left.id;
		arbitraryVal = string(other.magnitude);
		valueLength = string_width(arbitraryVal)*2 + 4;
		trg = other.id;
		sprWidth = (string_width(label) + 5) * 2;
		
		other.magnitudeId = self.id;
	}
	with instance_create_layer(x,y,"Instances",obj_panel_buton_input_num) {
		label = "Zoom Percent";
		
		sortIndex = 5;
		viewOn = 5;
		buttonType = 2;
		arbitraryVal = string(other.zoomVal);
		valueLength = string_width(arbitraryVal)*2 + 4;
		panelId = obj_subpanel_left.id;
		trg = other.id;
		sprWidth = (string_width(label) + 5) * 2;
		
		other.zoomId = self.id;
	}
	
	valueButtonsExist = true;
	
	event_user(0);
	
	#endregion
}

if select {
	// Make all vertices pink
	obj_trigger_vertex.sprite_index = spr_vector_marker_pink;
	obj_trigger_vertex.edgeColTemp = make_color_rgb(66,5,39);
	
	if width != widthTemp {
		// Recalculate polygons when width is changed
		widthTemp = width;
		recalculate = true;
	}
	
	// Create ds_list from ordered pairs of vertex coordinates
	if recalculate {
		recalculate = false;
		vertexCountTemp = 0;
		
		if instance_exists(obj_trigger_vertex) { // 0 vertices broke this system
			broken = false;
		}
		
		for (i = 0; i < instance_number(obj_trigger_vertex); i += 1) {
			if instance_find(obj_trigger_vertex,i).trg = self.id {
				vertexCountTemp += 1;
				tempInstanceStart = instance_find(obj_trigger_vertex,i).id; // Arbitrarily assign vertex n[0]
				
				if instance_find(obj_trigger_vertex,i).vertexToInd = -1 { // If the polygon is broken
					broken = true;
					
					break;
				}
			}
		}
		
		if vertexCountTemp <= 2 {
			// If the polygon is a single line
			broken = true;
		}
		
		if !broken {
			ds_list_clear(list); // Reset the list
			ds_list_clear(list2); // Reset the list
			tempInstanceVal = tempInstanceStart;
			
			i = 0; // Start from vertex n[0]
			while i < vertexCountTemp { // Iterate through all active vertices
				for (j = 0; j < instance_number(obj_trigger_vertex); j += 1) { // Iterate through every existent vertex
					if instance_find(obj_trigger_vertex,j).trg = self.id { // Reduce to exclusively active vertices
						if instance_find(obj_trigger_vertex,j).vertexInd = tempInstanceVal.vertexToInd { // Check if this vertex is next in order	
							tempInstanceVal = instance_find(obj_trigger_vertex,j).id;
							
							ds_list_add(list,tempInstanceVal.x);
							ds_list_add(list,tempInstanceVal.y);
							
							i += 1; // Move onto the next vertex
							break;
						}
					}
				}
			}
			
			// Generate lists of triangles
			polygon = scr_polygon_to_triangles(list);
		}
	}
	
	// These button instance couple to pass some values
	if instance_exists(obj_region_button_edge) {
		obj_region_button_edge.trg = self.id; 
	}
	if instance_exists(obj_region_button_threshold) {
		obj_region_button_threshold.trg = self.id;
	}
	if instance_exists(angleId) {
		if angleId != - 1 {
			self.angle = angleId.angle;
		}
	}
	if instance_exists(magnitudeId) {
		if magnitudeId != -1 {
			self.magnitude = magnitudeId.arbitraryVal;
		}
	}
	
	if valueButtonsExist {
		if instance_exists(zoomId) {
			if zoomId.arbitraryVal != "" {
				self.zoomVal = real(zoomId.arbitraryVal);
			} else {
				self.zoomVal = 100;
			}
		}
	}
} else {
	// Set collision mask to match the sprite mask when not selected
	width = 1;
}
