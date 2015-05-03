function sarsa_lam_start(h, dummy)
load thet_sarsa


if getappdata(0, 'learning_sarsa')==0
setappdata(0, 'learning_sarsa',1);
else
setappdata(0, 'learning_sarsa',0);
end
setappdata(0, 'thet_sarsa', thet);
for i=1:10

    create_ball_button_press;
    ball_move_down;
end
thet = getappdata(0, 'thet_sarsa');
save(cat(2,pwd,'/thet_sarsa'),'thet');
end