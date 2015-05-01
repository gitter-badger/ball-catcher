function ball_move_down(h, dummy)
balls = getappdata(0, 'balls');
    while balls{1}.pos(3)>=-1120
        ball_loop(100);
        pause(0.01);
        balls = getappdata(0, 'balls');
        
    end
    
  delete_balls;
    
end