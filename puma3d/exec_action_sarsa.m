function [feat,a]=exec_action_sarsa(sp,ap)
alp=0.2;
act=[[zeros(4,1);ones(4,1)],repmat([zeros(2,1);ones(2,1)],2,1),repmat([zeros(1,1);ones(1,1)],4,1)];
balls = getappdata(0, 'balls');
if nargin==0

thet = getappdata(0, 'thet_sarsa');


feat=[balls{1}.pos'-arm_tip'];
feat(feat<0)=0;
feat(feat>0)=1;

eps=0.01;
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
%tmp(3)=0;
new_pos=arm_tip'+alp*(tmp.*act(a,:)');
%new_pos=arm_tip'+alp*act(a,:)';
%if new_pos(3)>1401
 %   new_pos(3)=1200;
%end



[theta1,theta2,theta3,theta4,theta5,theta6] = arm_IK(new_pos(1),new_pos(2),new_pos(3));
theta3=theta3-180;
arm = getappdata(0, 'arm');
t1=arm.theta(1);
t2=arm.theta(2);
t3=arm.theta(3);

t1d=t1+alp*(theta1-t1);
t2d=t2+alp*(theta2-t2);
t3d=t3+alp*(theta3-t3);

%{
global exec_rew
global nogo
arm = getappdata(0, 'arm');
if nogo==1
    exec_rew=-1;
else
    
    exec_rew=-10*(abs(arm.theta(1:3)-[theta1,theta2,theta3]));
end
%}

n = 2;    % demo ani steps

%if nogo~=1
arm_animate(t1d, t2d, t3d, 0, 0, 0, n, 'y')
%end
end