/// @description Insert description here
draw_sprite_part(spr_editor_gui_streaks,0,0,0,scrollHorRightBound,(scrollVerBotBound+70),0,70);
event_inherited();

// Edge
draw_set_color(make_color_rgb(63,70,87));
draw_rectangle(x,70,x,576,false); // draw_line() is buggier

draw_sprite_ext(sprite_index,image_index,x,y-2,image_xscale,image_yscale,image_angle,c_white,image_alpha);
