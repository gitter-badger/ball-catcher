function [feat,a]=exec_action_sarsa(sp,ap)

eps = getappdata(0, 'epsilon');

alp=0.3;

act=[[zeros(4,1);ones(4,1)],repmat([zeros(2,1);ones(2,1)],2,1),repmat([zeros(1,1);ones(1,1)],4,1)];

balls = getappdata(0, 'balls');


if nargin==0

thet = getappdata(0, 'thet_sarsa');


feat=[balls{1}.pos'-arm_tip'];
feat(feat<0)=0;
feat(feat>0)=1;


q=thet'*feat;
pos=find(q==max(q));
a=pos(randi(length(pos)));
if rand(1)<eps
    tmp=[1:8]';
    tmp(tmp==a)=[];
    a=tmp(randi(length(tmp) ));
end


else
    feat=sp;
    a=ap;
end

tmp=[balls{1}.pos'-arm_tip'];


new_pos=arm_tip'+alp*(tmp.*act(a,:)');



[theta1,theta2,theta3,theta4,theta5,theta6] = arm_IK(new_pos(1),new_pos(2),new_pos(3));

theta3=theta3-180;

arm = getappdata(0, 'arm');
t1=arm.theta(1);
t2=arm.theta(2);
t3=arm.theta(3);

t1d=t1+alp*(theta1-t1);
t2d=t2+alp*(theta2-t2);
t3d=t3+alp*(theta3-t3);

n = 2;    % demo ani steps


arm_animate(t1d, t2d, t3d, 0, 0, 0, n, 'y')

end