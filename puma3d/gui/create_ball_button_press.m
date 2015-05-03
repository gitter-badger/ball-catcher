function create_ball_button_press(h, dummy)
%     min_axis = [-1500 -1500 -1120];
%     max_axis = [ 1500  1500  1500];
    min_axis = [-300 -300 10000];
    max_axis = [300  300 10000];
% randomly pick a point and it moves either left or right    
    ball_xyz = rand(1,3) .* (max_axis - min_axis) + min_axis;
    
    ball_init(ball_xyz, 100,[0,0,-1],[0,0,0]);
    
end

