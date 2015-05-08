function ball_loop(delta_time, use_gui)
    balls = getappdata(0, 'balls');
    use_clock = false;
    
    if nargin == 0
        use_clock = true;
        use_gui = true;
    elseif nargin >= 1
        use_clock = false;
        use_gui = true;
    end
    
    cur_time = clock;
    
    if use_gui
        [sphere_x, sphere_y, sphere_z] = sphere;
    end
    for i=1:length(balls)
        if use_clock
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