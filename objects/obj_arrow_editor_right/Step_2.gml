/// @description 
event_inherited();

if instance_exists(trg) {
	if select = 0 {
		x = trg.x + trg.width*20; // Right edge
	}
}
