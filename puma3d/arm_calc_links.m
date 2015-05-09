function [link1, link2, link3, link4, link5, link6, link7] = arm_calc_links(a1, a2, a3, a4, a5, a6, a7)
    arm = getappdata(0, 'arm');
    for i=1:size(arm,2)
    new_theta = arm(i).theta;
    trail = 'n';
    
    if nargin == 0
        
    elseif nargin == 1
        if ischar(a1)
            trail = a1;
        else
            new_theta = a1;
        end
    elseif nargin == 2
        new_theta = a1;
        trail = a2;
    elseif nargin == 6
        new_theta = [a1 a2 a3 a4 a5 a6];
    elseif nargin == 7
        new_theta = [a1 a2 a3 a4 a5 a6];
        trail = a7;
    else
        fprintf('Error : Invalid number of arguments\n');
        return
    end
    
    % Forward Kinematics using T-Matrix
    T_01 = tmat(0, 0, 0, new_theta(1));
    T_12 = tmat(-90, 0, 0, new_theta(2));
    T_23 = tmat(0, arm(i).a2, arm(i).d3, new_theta(3));
    T_34 = tmat(-90, arm(i).a3, arm(i).d4, new_theta(4));
    T_45 = tmat(90, 0, 0, new_theta(5));
    T_56 = tmat(-90, 0, 0, new_theta(6));

    % Each (link frame) to (base frame) transformation
    T_02 = T_01 * T_12;
    T_03 = T_02 * T_23;
    T_04 = T_03 * T_34;
    T_05 = T_04 * T_45;
    T_06 = T_05 * T_56;

    % Actual transformed vertex data of robot links
    % All links are different sizes. So, it can't be kept in an array
    link1 = arm(i).link_data.s1.V1;
    link2 = (T_01 * arm(i).link_data.s2.V2')';
    link3 = (T_02 * arm(i).link_data.s3.V3')';
    link4 = (T_03 * arm(i).link_data.s4.V4')';
    link5 = (T_04 * arm(i).link_data.s5.V5')';
    link6 = (T_05 * arm(i).link_data.s6.V6')';
    link7 = (T_06 * arm(i).link_data.s7.V7')';
    
    arm(i).link1 = link1;
    arm(i).link2 = link2;
    arm(i).link3 = link3;
    arm(i).link4 = link4;
    arm(i).link5 = link5;
    arm(i).link6 = link6;
    arm(i).link7 = link7;
    
    % store trail in appdata 
    if trail == 'y'
        arm(i).trail = [arm(i).trail T_04(1:3, 4)];
        %disp(arm.tail);
        %disp(trail);
    end
    end
    setappdata(0, 'arm', arm);
end