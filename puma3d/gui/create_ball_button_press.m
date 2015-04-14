function create_ball_button_press(h, dummy)
    min_axis = [-1500 -1500 -1120];
    max_axis = [ 1500  1500  1500];
    
    ball_xyz = rand(1,3) .* (max_axis - min_axis) + min_axis;
    
    ball_init(ball_xyz, 50);

end