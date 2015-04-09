function rnd_demo_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    home_pos = getappdata(0, 'home_pos');
    min_pos = getappdata(0, 'min_pos');
    max_pos = getappdata(0, 'max_pos');
    
    theta = zeros(1, 6);
    for i=1:6
        theta(i) = min_pos(i) + (max_pos(i)-min_pos(i))*rand(1);
    end
    n = 50;
    abs_theta = theta + home_pos;
    pumaANI(abs_theta(1), abs_theta(2), abs_theta(3), abs_theta(4), ...
        abs_theta(5), abs_theta(6), n, 'y')
    for i=1:6
        set(kin_panel.theta(i).edit, 'string',round(theta(i)));
        set(kin_panel.theta(i).slider, 'Value',round(theta(i)));
    end
end