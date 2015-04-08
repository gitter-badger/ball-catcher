function demo_button_press(h,dummy)
        global t1_edit;
        global t1_slider;
        global t2_edit;
        global t2_slider;
        global t3_edit;
        global t3_slider;
        %
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
            [theta1,theta2,theta3,theta4,theta5,theta6] = PumaIK(Px,Py,Pz);
            if t==0 %move to start of demo
                pumaANI(theta1,theta2,theta3-180,0,0,0,num,'n')
            end
            % Theta 4, 5 & 6 are zero due to plotting at wrist origen.
            pumaANI(theta1,theta2,theta3-180,0,0,0,n,'y')
            
            set(t1_edit,'string',round(theta1)); % Update slider and text.
            set(t1_slider,'Value',round(theta1));
            set(t2_edit,'string',round(theta2));
            set(t2_slider,'Value',round(theta2));
            set(t3_edit,'string',round(theta3-180));
            set(t3_slider,'Value',round(theta3-180));
        end
        gohome
%        pumaANI(90,-90,-90,0,0,0,num,'n')
    end