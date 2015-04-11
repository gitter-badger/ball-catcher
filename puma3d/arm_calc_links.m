function [link1, link2, link3, link4, link5, link6, link7] = arm_calc_links(new_theta)
    arm = getappdata(0, 'arm');
    
    if nargin < 1
        new_theta = arm.theta;
    end
    
    % Forward Kinematics using T-Matrix
    T_01 = tmat(0, 0, 0, new_theta(1));
    T_12 = tmat(-90, 0, 0, new_theta(2));
    T_23 = tmat(0, arm.a2, arm.d3, new_theta(3));
    T_34 = tmat(-90, arm.a3, arm.d4, new_theta(4));
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
    link1 = arm.link_data.s1.V1;
    link2 = (T_01 * arm.link_data.s2.V2')';
    link3 = (T_02 * arm.link_data.s3.V3')';
    link4 = (T_03 * arm.link_data.s4.V4')';
    link5 = (T_04 * arm.link_data.s5.V5')';
    link6 = (T_05 * arm.link_data.s6.V6')';
    link7 = (T_06 * arm.link_data.s7.V7')';
    
    arm.link1 = link1;
    arm.link2 = link2;
    arm.link3 = link3;
    arm.link4 = link4;
    arm.link5 = link5;
    arm.link6 = link6;
    arm.link7 = link7;
    
    setappdata(0, 'arm', arm);
end