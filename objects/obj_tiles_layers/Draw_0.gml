/// @description 
subPointDisplacement = 0;

// Draw tileset name
if resourceSelect || resourceCanSelect {
	draw_set_color(insideCol);
	draw_rectangle(x+2, y, x+1+string_width(tileDefaultSpr), y + 11-2, false);
	draw_set_font(obj_editor_gui.fontDark);
} else {
	draw_set_color(graphicCol1);
	draw_set_font(obj_editor_gui.font);
}

draw_text(x+2, y, tileDefaultSpr);

for (i = 0; i <= tileLayerCount; i += 2) {
	draw_sprite_ext(spr_layer_rack,0,x + 12, y + 11 + i*11,1,1,0,graphicCol1,1);
	
	if i != tileLayerCount {
		draw_sprite_ext(spr_layer_rack,0,x + 12, y + 11 + (i+1)*11,1,1,0,graphicCol1,1);
	}
	
	draw_sprite_ext(spr_point,0,x + 31, y + 11 + 6 + layerOrder[i] * 11,1,1,0,graphicCol1,layerAlpha[i]);
	draw_sprite_ext(spr_layer_eye,eyeState[i],x + 22, y + 11 + 6 + layerOrder[i] *11,1,1,0,eyeCol[i],1);
	
	draw_sprite_ext(spr_layer_slot,0,x + 2, y + 11 + 1 + i*11,1,1,0,graphicCol1,1);
	
	draw_set_font(obj_editor_gui.fontDark);
	draw_set_color(graphicCol1);
	draw_text(x + 2,y + 11 + 2 + i * 11,string( (i div 2) + 1) );
	
	// Layer
	if canSelectLayer[i] || selectLayer[i] && !(i = dragLayer && draggingMouse) {
		draw_set_color(insideCol);
		draw_rectangle(x+37,y + 11+2+layerOrder[i]*11,x+37+string_width(layerName[i]),y + 11+11+layerOrder[i]*11,false);
		
		draw_set_font(obj_editor_gui.fontDark);
		draw_set_color(insideCol);
	} else {
		draw_set_font(obj_editor_gui.font);
		draw_set_color(graphicCol1);
		draw_set_alpha(layerAlpha[i]);
	}
	
	draw_text(x + 37,y + 11 + 2 + layerOrder[i] * 11,layerName[i]);
	draw_set_alpha(1);
	
	draw_sprite_ext(spr_layer_minus,0,x + 37, y + 11 + 18 + layerOrder[i] * 11,1,1,0,graphicCol1,layerAlpha[i]);
	
	// Sub-layer
	if canSelectLayer[i+1] || selectLayer[i+1] && !(i = dragLayer && draggingMouse) {
		draw_set_color(insideCol);
		draw_rectangle(x + 43, y + 11 + 2 + (layerOrder[i] + 1) * 11, x + 43 + string_width(layerName[i+1]), y + 11 + 11 + (layerOrder[i] + 1) * 11, false);
		
		draw_set_font(obj_editor_gui.fontDark);
		draw_set_color(insideCol);
	} else {
		draw_set_font(obj_editor_gui.font);
		draw_set_color(graphicCol1);
		draw_set_alpha(layerAlpha[i]);
	}
	
	draw_text(x + 43,y + 11 + 2 + (layerOrder[i] + 1) * 11,layerName[i+1]);
	draw_set_alpha(1);
}

// Draw scroll markers last
for (i = 0; i <= tileLayerCount; i += 2) {
	draw_sprite_ext(spr_layer_place,0,x + 11,y + 11 + 1 + layerOrder[i]*11,1,1,0,graphicCol1,1);
}

// New layer icons
draw_sprite_ext(spr_layer_plus,0,x + 31, y + 11 + 6 + (tileLayerCount + 2) * 11,1,1,0,plusCol,1);
draw_sprite_ext(spr_layer_die,0,x + 41, y + 11 + 6 + (tileLayerCount + 2) * 11,1,1,0,dieCol,1);
