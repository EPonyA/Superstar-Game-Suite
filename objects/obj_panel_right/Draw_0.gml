/// @description Insert description here
draw_sprite_tiled_area(spr_editor_gui_streaks,0,0,0,x,obj_panel_top.y + 11,room_width + view_get_wport(1),obj_panel_bot.y + 1);

event_inherited();

// Edge
draw_set_color(make_color_rgb(63,70,87));
draw_rectangle(x-1,obj_panel_top.y + 11,x-1,view_hport[1],false); // draw_line() is buggier

draw_sprite_ext(sprite_index,image_index,x,y-2,image_xscale,image_yscale,image_angle,c_white,image_alpha);
