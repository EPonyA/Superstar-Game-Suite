/// @description 
event_inherited();

if select {
	select = false;
	
	if !instance_exists(obj_cutscene_rotate_target) {
		with instance_create_layer(trg.x+10,trg.y+10,"Instances",obj_cutscene_rotate_target) {
			canPlace = false;
			canDel = true;
			calcAngleVals = true;
			
			trg = other.trg; // obj_npc_position
			originX[0] = x;
			originY[0] = y;
			
			zfloor = trg.zfloor;
			angle = other.angle;
		}
	}
}
