function go_home()
    kin_panel = getappdata(0, 'kin_panel');
    arm = getappdata(0, 'arm');
    
    arm_animate(arm.home_pos, 20, 'n') % show it animate home
%     pumaPOS(home_pos(1), home_pos(2), home_pos(3), ...
%         home_pos(4), home_pos(5), home_pos(6))  %drive it home, no animate.
    
    for i=1:6
        set(kin_panel.theta(i).edit, 'string',0);
        set(kin_panel.theta(i).edit, 'Value', 0);
    end
    
    setappdata(0, 'arm', arm);
    setappdata(0, 'kin_panel', kin_panel);
end