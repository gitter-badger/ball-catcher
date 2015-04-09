function rnd_demo_button_press(h, dummy)
        global t1_edit t1_slider t2_edit t2_slider t3_edit t3_slider;
        global t4_edit t4_slider t5_edit t5_slider t6_edit t6_slider;
        
        %disp('pushed random demo bottom');
        % a = 10; b = 50; x = a + (b-a) * rand(5)
        %     Angle    Range                Default Name
        %     Theta 1: 320 (-160 to 160)    90       Waist Joint
        %     Theta 2: 220 (-110 to 110)    -90       Shoulder Joint
        %     Theta 3: 270 (-135 to 135)    -90       Elbow Joint
        %     Theta 4: 532 (-266 to 266)    0       Wrist Roll
        %     Theta 5: 200 (-100 to 100)    0       Wrist Bend
        %     Theta 6: 532 (-266 to 266)    0       Wrist Swival
        
        t1_home = 90; % offsets to define the "home" postition as UP.
        t2_home = -90;
        t3_home = -90;
        theta1 = -160 + 320*rand(1); % offset for home
        theta2 = -110 + 220*rand(1); % in the UP pos.
        theta3 = -135 + 270*rand(1);
        theta4 = -266 + 532*rand(1);
        theta5 = -100 + 200*rand(1);
        theta6 = -266 + 532*rand(1);
        n = 50;
        
        pumaANI(theta1+t1_home,theta2+t2_home,theta3+t3_home,theta4,theta5,theta6,n,'y')
        set(t1_edit,'string',round(theta1)); % Update slider and text.
        set(t1_slider,'Value',round(theta1));
        set(t2_edit,'string',round(theta2));
        set(t2_slider,'Value',round(theta2));
        set(t3_edit,'string',round(theta3));
        set(t3_slider,'Value',round(theta3));
        set(t4_edit,'string',round(theta4));
        set(t4_slider,'Value',round(theta4));
        set(t5_edit,'string',round(theta5));
        set(t5_slider,'Value',round(theta5));
        set(t6_edit,'string',round(theta6));
        set(t6_slider,'Value',round(theta6));
    end