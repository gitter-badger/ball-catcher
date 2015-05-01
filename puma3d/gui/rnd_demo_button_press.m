function rnd_demo_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    arm = getappdata(0, 'arm');
    
    theta = arm.min_pos + (arm.max_pos-arm.min_pos) .* rand(1, 6);
    
    n = 50;
    abs_theta = theta + arm.home_pos;
    arm_animate(abs_theta, n, 'y')
    for i=1:6
        set(kin_panel.theta(i).edit, 'string',round(theta(i)));
        set(kin_panel.theta(i).slider, 'Value',round(theta(i)));
    end
    setappdata(0, 'kin_panel', kin_panel);
    
end