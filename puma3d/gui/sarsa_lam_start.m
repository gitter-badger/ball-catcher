function sarsa_lam_start(h, dummy)
    load thet_sarsa

    if getappdata(0, 'learning_sarsa')==0
    setappdata(0, 'learning_sarsa',1);
    else
    setappdata(0, 'learning_sarsa',0);
    end
    setappdata(0, 'thet_sarsa', thet);
    
    
    eps=0.1;
    setappdata(0, 'epsilon', eps);
    
    
    for i=1:10
        e = zeros(3,8);
        setappdata(0, 'elig_trace', e);
        create_ball_button_press;
        ball_move_down;
    end
    thet = getappdata(0, 'thet_sarsa');
    save(cat(2,pwd,'/thet_sarsa'),'thet');
end