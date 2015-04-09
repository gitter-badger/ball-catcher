function rnd_demo_button_press(h, dummy)
    kin_panel = getappdata(0, 'kin_panel');
    home_pos = getappdata(0, 'home_pos');

    %disp('pushed random demo bottom');
    % a = 10; b = 50; x = a + (b-a) * rand(5)
    %     Angle    Range                Default Name
    %     Theta 1: 320 (-160 to 160)    90       Waist Joint
    %     Theta 2: 220 (-110 to 110)    -90       Shoulder Joint
    %     Theta 3: 270 (-135 to 135)    -90       Elbow Joint
    %     Theta 4: 532 (-266 to 266)    0       Wrist Roll
    %     Theta 5: 200 (-100 to 100)    0       Wrist Bend
    %     Theta 6: 532 (-266 to 266)    0       Wrist Swival

    theta1 = -160 + 320*rand(1); % offset for home
    theta2 = -110 + 220*rand(1); % in the UP pos.
    theta3 = -135 + 270*rand(1);
    theta4 = -266 + 532*rand(1);
    theta5 = -100 + 200*rand(1);
    theta6 = -266 + 532*rand(1);
    n = 50;

    pumaANI(theta1 + home_pos.t1, theta2 + home_pos.t2, ...
        theta3 + home_pos.t3, theta4, theta5, theta6,n,'y')
    set(kin_panel.t1.edit,'string',round(theta1)); % Update slider and text.
    set(kin_panel.t1.slider,'Value',round(theta1));
    set(kin_panel.t2.edit,'string',round(theta2));
    set(kin_panel.t2.slider,'Value',round(theta2));
    set(kin_panel.t3.edit,'string',round(theta3));
    set(kin_panel.t3.slider,'Value',round(theta3));
    set(kin_panel.t4.edit,'string',round(theta4));
    set(kin_panel.t4.slider,'Value',round(theta4));
    set(kin_panel.t5.edit,'string',round(theta5));
    set(kin_panel.t5.slider,'Value',round(theta5));
    set(kin_panel.t6.edit,'string',round(theta6));
    set(kin_panel.t6.slider,'Value',round(theta6));
end