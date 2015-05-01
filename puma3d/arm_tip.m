function [tip] = arm_tip()
    arm = getappdata(0, 'arm');
    [tip]=mean(arm.link7(:,1:3));
end