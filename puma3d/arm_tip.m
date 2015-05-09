function [tip] = arm_tip
    arm = getappdata(0, 'arm');
    for i=1:size(arm,2)
    tip(i,:)=mean(arm(i).link7(:,1:3));
    end
end