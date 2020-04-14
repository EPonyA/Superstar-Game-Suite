var colNorth = false;
var colSouth = false;
var colWest = false;
var colEast = false;
var trgScr;

var slopeOffset;
var j;
var run;
var rise;
var actorXOrigin;
var actorYOrigin;
var ax = floor(x);
var ay = floor(y);

repeat(2) {
	// Staircase collision
	//show_debug_message(" ");
	onStaircase = false;
	
	if collision_rectangle(ax, ay, ax + 1, ay + 1, obj_staircase_collision, false, false) {
		if !onStaircase {
			staircaseId = collision_rectangle(ax, ay, ax + 1, ay + 1, obj_staircase_collision, false, false);
			//staircaseId = collision_point(floor(x), floor(y), obj_staircase_collision, false, false);
			
			run  = staircaseId.angleRise;
			rise = -staircaseId.angleRun;
			
			for (var i = 0; i <= staircaseId.width * 20; i += 0.5) {
				staircaseId.lineX1[i] = staircaseId.xStairs + i*run;
				staircaseId.lineY1[i] = staircaseId.yStairs + i*rise + (staircaseId.zfloor - staircaseId.zcieling)*20 + self.zfloor*20;
				staircaseId.lineX2[i] = staircaseId.xStairs + i*run + staircaseId.angleRun*staircaseId.staircaseN;
				staircaseId.lineY2[i] = staircaseId.yStairs + i*rise + staircaseId.angleRise*staircaseId.staircaseN + (staircaseId.zfloor - staircaseId.zcieling)*20 + self.zfloor*20;
				
				//if collision_line(staircaseId.x + i*run, staircaseId.y + i*rise, staircaseId.x + i*run + staircaseId.angleRun*staircaseId.staircaseN, staircaseId.y + i*rise + staircaseId.angleRise*staircaseId.staircaseN,obj_staircasecollision_mask,true,false) {
				if collision_line(staircaseId.lineX1[i], staircaseId.lineY1[i], staircaseId.lineX2[i], staircaseId.lineY2[i],obj_staircase_collision_mask, false, false) {
					// Iterating across the tall and wide edge of the staircase, and casting a ray down the steps.
					if !onStaircase {
						actorXOrigin = staircaseId.xStairs + i*run + staircaseId.angleRun*staircaseId.staircaseN;
						actorYOrigin = staircaseId.yStairs + i*rise + staircaseId.zfloor*20  + staircaseId.angleRise*staircaseId.staircaseN;
						onStaircase = true; // Used to over ride depth algorithm
					}
					
					//jumpHeight = staircaseId.zfloor*20 + ( (actorXOrigin - self.x)*(staircaseId.stairstepRun) + (actorYOrigin - self.y)*(staircaseId.stairstepRise) );
					jumpHeight = clamp(staircaseId.zcieling*20 + ( point_distance(actorXOrigin, actorYOrigin, x, y) / staircaseId.staircaseN * staircaseId.zfloor*20 ), staircaseId.zcieling*20, staircaseId.zfloor*20);
					
					break;
				}
				
				if i = staircaseId.width*20 {
					onStaircase = false;
					actorXOrigin = -1;
					actorYOrigin = -1;
				}
			}
			
			staircaseId.lineX1[i] = -1;
			staircaseId.xOrigina = actorXOrigin;
			staircaseId.yOrigina = actorYOrigin;
		}
	}
	
	/*if onStaircase {
		jumpHeight = staircaseId.zfloor*20 + (actorXOrigin - self.x)*(staircaseId.angleRise) + (actorYOrigin - self.y)*(-staircaseId.angleRun);
	}*/
	if !onStaircase {
		for (var i = 0; i < instance_number(obj_solid); i += 1) {
			trgScr = instance_find(obj_solid,i).id;
			if (trgScr.zheight*20 > self.jumpHeight && trgScr.zcieling*20 <= self.jumpHeight) || !(trgScr.finite) {
				// Checking for negative y collision at current z coordinate
				if collision_rectangle(bbox_left,bbox_top-1,bbox_right,bbox_top-1,trgScr,false,true) {
					colNorth = collision_rectangle(bbox_left,bbox_top-1,bbox_right,bbox_top-1,trgScr,false,true);
				}
				// Checking for positive y collision at current z coordinate
				if collision_rectangle(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,trgScr,false,true) {
					colSouth = collision_rectangle(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,trgScr,false,true);
				}
			}
		}
		
		for (var i = 0; i < instance_number(obj_solid_side); i += 1) {
			trgScr = instance_find(obj_solid_side,i).id;
			if (trgScr.zheight*20 > self.jumpHeight && trgScr.zcieling*20 <= self.jumpHeight) || !(trgScr.finite) {
				// Checking for negative x collision at current z coordinate
				if collision_rectangle(bbox_left-1,bbox_top,bbox_left-1,bbox_bottom-4,trgScr,false,true) {
					colWest = collision_rectangle(bbox_left-1,bbox_top,bbox_left,bbox_bottom-4,trgScr,false,true);
				}
			
				// Checking for positive x collision at current z coordinate
				if collision_rectangle(bbox_right+1,bbox_top,bbox_right+1,bbox_bottom-4,trgScr,false,true) {
					colEast = collision_rectangle(bbox_right+1,bbox_top,bbox_right,bbox_bottom-4,trgScr,false,true);
				}
			}
		}
	
	  //---Solids---
	  if colNorth
	  {
	    if add_y <= 0
	    add_y = 0;
	    if c_vspeed <= 0
	    c_vspeed = 0
   
	    if collision_rectangle(bbox_left,bbox_top,bbox_right,bbox_top,colNorth,false,true) {
	        y += 1;
	    }
	  }
   
	  if colSouth
	  {
	    if add_y >= 0 {
		    add_y = 0;
		}
	    if c_vspeed >= 0 {
			c_vspeed = 0;
		}
   
	    if collision_rectangle(bbox_left,bbox_bottom,bbox_right,bbox_bottom,colSouth,false,true) {
		    y -= 1;
		}
	  }
   
	  if colWest
	  {
	    if add_x <= 0
	    add_x = 0;
	    if c_hspeed <= 0
	    c_hspeed = 0
   
	    if collision_rectangle(bbox_left,bbox_top,bbox_left,bbox_bottom,colWest,false,true) {
	        x += 1;
	    }
	  }
   
	  if colEast
	  {
	    if add_x >= 0
	    add_x = 0;
	    if c_hspeed >= 0
	    c_hspeed = 0
   
	    if collision_rectangle(bbox_right,bbox_top,bbox_right,bbox_bottom,colEast,false,true) {
	        x -= 1;
	    }
	  }
  
		// Unflipped Slopes
		repeat(abs(c_hspeed)) {
			// Vertical slopes displacement
			if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_bot,true,false) {
				if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_bot,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_bot,true,false).slopeOffset;
				
					if c_hspeed < 0 {
						y -= c_hspeed / slopeOffset;
					}
				}
			}
			if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_bot,true,false) {
				if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_bot,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_bot,true,false).slopeOffset;
				
					if c_hspeed > 0 {
						y += c_hspeed / slopeOffset;
					}
				}
			}
		}
		repeat(abs(c_vspeed)) {
			// Horizontal slopes displacement
			if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_bot,true,false) {
				if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_bot,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_bot,true,false).slopeOffset;
				
					if c_vspeed < 0 {
						x -= c_vspeed * slopeOffset;
					}
				}
			}
			if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_bot,true,false) {
				if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_bot,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_bot,true,false).slopeOffset;
				
					if c_vspeed < 0 {
						x += c_vspeed * slopeOffset;
					}
				}
			}
		}
	
		// Flipped Slopes
		repeat(abs(c_hspeed)) {
			// Vertical slopes displacement
			if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_top,true,false) {
				if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_top,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_top,true,false).slopeOffset;
				
					if c_hspeed < 0 {
						y += c_hspeed / slopeOffset;
					}
				}
			}
			if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_top,true,false) {
				if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_top,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_top,true,false).slopeOffset;
				
					if c_hspeed > 0 {
						y -= c_hspeed / slopeOffset;
					}
				}
			}
		}
		repeat(abs(c_vspeed)) {
			// Horizontal slopes displacement
			if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_top,true,false) {
				if collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_top,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,obj_slopeL_top,true,false).slopeOffset;
				
					if c_vspeed > 0 {
						x += c_vspeed * slopeOffset;
					}
				}
			}
			if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_top,true,false) {
				if collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_top,true,false).zplace*20 > self.jumpHeight {
					slopeOffset = collision_rectangle(bbox_left-1,bbox_top,bbox_right,bbox_bottom-1,obj_slopeR_top,true,false).slopeOffset;
				
					if c_vspeed > 0 {
						x -= c_vspeed * slopeOffset;
					}
				}
			}
		}
	}
}

