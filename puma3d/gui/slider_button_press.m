function slider_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    arm = getappdata(0, 'arm');
    for j=1:size(arm,2)
    theta_values = zeros(size(arm(j).home_pos));
    for i=1:size(arm(j).home_pos, 2)
        slider_value = round(get(kin_panel.theta(i).slider, 'Value'));
        theta_values(i) = arm(j).home_pos(i) + slider_value;
        set(kin_panel.theta(i).edit, 'string', slider_value);
    end
    
    arm_animate(theta_values, 10,'n')
    end
end