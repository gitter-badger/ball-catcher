function ball_loop(delta_time, use_gui)
    balls = getappdata(0, 'balls');
    if nargin == 1
        use_gui = true;
    end
    cur_time = clock;
    
    if use_gui
        [sphere_x, sphere_y, sphere_z] = sphere;
    end
    for i=1:length(balls)
        
        if nargin == 0
            delta_time = etime(cur_time, balls{i}.last_updated);
        end
        balls{i}.pos = balls{i}.pos + delta_time * balls{1}.vel ...
             + 0.5*delta_time * delta_time * balls{i}.acc;
        balls{i}.last_updated = cur_time;
        if use_gui
            set(balls{i}.handler, ...
                'XData', sphere_x * balls{i}.radius + balls{i}.pos(1), ...
                'YData', sphere_y * balls{i}.radius + balls{i}.pos(2), ...
                'ZData', sphere_z * balls{i}.radius + balls{i}.pos(3) );
        end
    end
    
    setappdata(0, 'balls', balls);
end