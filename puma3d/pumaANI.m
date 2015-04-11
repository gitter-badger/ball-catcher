function pumaANI(theta1,theta2,theta3,theta4,theta5,theta6,n,trail)
    % This function will animate the Puma 762 robot given joint angles.
    % n is number of steps for the animation
    % trail is 'y' or 'n' (n = anything else) for leaving a trail.
    %
    %disp('in animate');
    a2 = 650; %D-H paramaters
    a3 = 0;
    d3 = 190;
    d4 = 600;
    % Err2 = 0;
    %
    arm = getappdata(0, 'arm');
    %
    t1 = linspace(arm.theta_old(1), theta1, n); 
    t2 = linspace(arm.theta_old(2), theta2, n); 
    t3 = linspace(arm.theta_old(3), theta3, n);% -180;  
    t4 = linspace(arm.theta_old(4), theta4, n); 
    t5 = linspace(arm.theta_old(5), theta5, n); 
    t6 = linspace(arm.theta_old(6), theta6, n); 

    n = length(t1);
    for i = 2:1:n
        % Forward Kinematics
        %
        T_01 = tmat(0, 0, 0, t1(i));
        T_12 = tmat(-90, 0, 0, t2(i));
        T_23 = tmat(0, a2, d3, t3(i));
        T_34 = tmat(-90, a3, d4, t4(i));
        T_45 = tmat(90, 0, 0, t5(i));
        T_56 = tmat(-90, 0, 0, t6(i));

% 
%             %     T_67 = [   1            0      0 0
%             %                0            1      0 0
%             %                0            0      1 188
%             %                0            0      0 1];

        %T_01 = T_01;  % it is, but don't need to say so.
        T_02 = T_01*T_12;
        T_03 = T_02*T_23;
        T_04 = T_03*T_34;
        T_05 = T_04*T_45;
        T_06 = T_05*T_56;
        %     T_07 = T_06*T_67;
        %
        link_data = getappdata(0, 'link_data');

        Link1 = link_data.s1.V1;
        Link2 = (T_01 * link_data.s2.V2')';
        Link3 = (T_02 * link_data.s3.V3')';
        Link4 = (T_03 * link_data.s4.V4')';
        Link5 = (T_04 * link_data.s5.V5')';
        Link6 = (T_05 * link_data.s6.V6')';
        Link7 = (T_06 * link_data.s7.V7')';
        %     Tool = T_07;

        %     if sqrt(Tool(1,4)^2+Tool(2,4)^2)<514
        %         Err2 = 1;
        %         break
        %     end
        %
        handles = getappdata(0,'patch_h');           %
        L1 = handles(1);
        L2 = handles(2);
        L3 = handles(3);
        L4 = handles(4);
        L5 = handles(5);
        L6 = handles(6);
        L7 = handles(7);
        Tr = handles(9);
        %
        set(L1,'vertices',Link1(:,1:3),'facec', [0.717,0.116,0.123]);
        set(L1, 'EdgeColor','none');
        set(L2,'vertices',Link2(:,1:3),'facec', [0.216,1,.583]);
        set(L2, 'EdgeColor','none');
        set(L3,'vertices',Link3(:,1:3),'facec', [0.306,0.733,1]);
        set(L3, 'EdgeColor','none');
        set(L4,'vertices',Link4(:,1:3),'facec', [1,0.542,0.493]);
        set(L4, 'EdgeColor','none');
        set(L5,'vertices',Link5(:,1:3),'facec', [0.216,1,.583]);
        set(L5, 'EdgeColor','none');
        set(L6,'vertices',Link6(:,1:3),'facec', [1,1,0.255]);
        set(L6, 'EdgeColor','none');
        set(L7,'vertices',Link7(:,1:3),'facec', [0.306,0.733,1]);
        set(L7, 'EdgeColor','none');
        
        % store trail in appdata 
        if trail == 'y'
            x_trail = getappdata(0,'xtrail');
            y_trail = getappdata(0,'ytrail');
            z_trail = getappdata(0,'ztrail');
            %
            xdata = [x_trail T_04(1, 4)];
            ydata = [y_trail T_04(2, 4)];
            zdata = [z_trail T_04(3, 4)];
            %
            setappdata(0,'xtrail',xdata); % used for trail tracking.
            setappdata(0,'ytrail',ydata); % used for trail tracking.
            setappdata(0,'ztrail',zdata); % used for trail tracking.
            %
            set(Tr,'xdata',xdata,'ydata',ydata,'zdata',zdata);
        end
        drawnow
    end
    arm.theta_old(1) = theta1;
    arm.theta_old(2) = theta2;
    arm.theta_old(3) = theta3;
    arm.theta_old(4) = theta4;
    arm.theta_old(5) = theta5;
    arm.theta_old(6) = theta6;
    setappdata(0, 'arm', arm);
end