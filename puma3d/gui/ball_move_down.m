function ball_move_down(h, dummy)
    
    while 1
        balls = getappdata(0, 'balls');
        ball_del_ids = [];
        
        for i=1:length(balls)
            if balls{i}.pos(3) <= -1120
                ball_del_ids = [ball_del_ids i];
            end
        end
        ball_del(ball_del_ids);
        
        balls = getappdata(0, 'balls');
        if length(balls) == 0 
            break
        end
        ball_loop(100);
        pause(0.1);
    end
    
end