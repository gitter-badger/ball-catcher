function ball_loop()
    balls = getappdata(0, 'balls');
    
    cur_time = clock;
    
    [sphere_x, sphere_y, sphere_z] = sphere;
    for i=1:length(balls)
        
        
        delta_time = etime(cur_time, balls{1}.last_updated);
        
        balls{1}.pos = balls{1}.pos + delta_time * balls{1}.vel ...
             + delta_time * delta_time * balls{1}.acc;
        balls{1}.last_updated = cur_time;
        set(balls{1}.handler, ...
            'XData', sphere_x * balls{1}.radius + balls{1}.pos(1), ...
            'YData', sphere_y * balls{1}.radius + balls{1}.pos(2), ...
            'ZData', sphere_z * balls{1}.radius + balls{1}.pos(3) );
        
    end
    
    setappdata(0, 'balls', balls);
end