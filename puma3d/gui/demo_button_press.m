function demo_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    
    % disp('pushed demo bottom');
    %         R = 500;
    %         x = 1000;
    n = 2;    % demo ani steps
    num = 30; % home to start, and end to home ani steps
    %         j = 1;
    %         M = 1000;
    for t = 0:.1:7*pi
        Px = 30*t*cos(t);
        Py = 1200-300*t*(t)/(50*pi);
        Pz = 30*t*sin(t);
        [theta1,theta2,theta3,theta4,theta5,theta6] = pumaIK(Px,Py,Pz);
        if t==0 % move to start of demo
            pumaANI(theta1,theta2,theta3-180,0,0,0,num,'n')
        end
        
        % Theta 4, 5 & 6 are zero due to plotting at wrist origen.
        pumaANI(theta1, theta2, theta3-180, 0, 0, 0, n, 'y')

        set(kin_panel.theta(1).edit, 'string', round(theta1)); % Update slider and text.
        set(kin_panel.theta(1).slider, 'Value', round(theta1));
        set(kin_panel.theta(2).edit, 'string', round(theta2));
        set(kin_panel.theta(2).slider, 'Value', round(theta2));
        set(kin_panel.theta(3).edit, 'string', round(theta3-180));
        set(kin_panel.theta(3).slider, 'Value', round(theta3-180));
    end
    go_home
end