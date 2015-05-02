function ball_move_down(h, dummy)
score = getappdata(0, 'score');
balls = getappdata(0, 'balls');
eps=200;
cur_sc=get(score.edit,'string');
cur_sc=str2double(cur_sc);
    while balls{1}.pos(3)>=-1120
        ball_loop(100);
        pause(0.01);
        balls = getappdata(0, 'balls');
        
        if pdist2(balls{1}.pos,arm_tip)<eps
            
            cur_sc=cur_sc+1;
        end
        
    end
    set(score.edit, 'string',cur_sc);
    setappdata(0, 'score', score);
  delete_balls;
    
end