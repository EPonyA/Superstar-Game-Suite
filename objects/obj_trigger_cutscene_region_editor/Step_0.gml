/// @description Manipulating dimensions
event_inherited();

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
	
	recalculate = true; // Generate polygon
	placed = 2;
	
	#endregion
}

// Dimensional manipulation
if spawnButtons {
	#region
	
	spawnButtons = false;
	
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
			alarm[0] = 2; // Delay until vertices respond to mouse input
		}
	}
	
	#endregion
}

// Trigger manipulation
if spawnTriggers {
	#region
	
	spawnTriggers = false;
	
	with instance_create_layer(x,y,"Instances",obj_region_button_vertex) {
		sortIndex = 0;
		viewOn = 2;
		panelId = obj_panel_left.id;
		sprWidth = (string_width(label) + 5) * 2;
		trg = other.id;
	}
	with instance_create_layer(x,y,"Instances",obj_region_button_edge) {
		label = "Edge";
		sprite_index = spr_editor_region_edge;
		
		sortIndex = 1;
		viewOn = 2;
		panelId = obj_panel_left.id;
		sprWidth = (string_width(label) + 5) * 2;
		trg = other.id;
	}
	with instance_create_layer(x,y,"Instances",obj_actor_button_new) {
		label = "New Event";
		
		sortIndex = 2;
		viewOn = 2;
		panelId = obj_panel_left.id;
		sprWidth = (string_width(label) + 5) * 2;
		trg = other.id;
	}
	
	for (i = 0; i < eventsCount; i++) {
		with instance_create_layer(x,y,"Instances",obj_actor_button_scene) {
			label = "Event " + string(other.i + 1);
			sprite_index = spr_editor_trigger_scene;
			eventIndex = other.i;
			
			sortIndex = 3 + other.i;
			viewOn = 2;
			panelId = obj_panel_left.id;
			sprWidth = (string_width(label) + 5) * 2;
			trg = other.id;
		}
	}
	
	scr_panel_calc(obj_panel_left.id);
	
	#endregion
}

zcieling = zfloor;

// Create ds_list from ordered pairs of vertex coordinates
if recalculate {
	#region
	
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
		tempInstanceVal = tempInstanceStart;
		
		i = 0; // Start from vertex n[0]
		while i < vertexCountTemp { // Iterate through the number of active vertices
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
		
		// Generate list of triangles
		polygon = scr_polygon_to_triangles(list);
	}
	
	#endregion
}
