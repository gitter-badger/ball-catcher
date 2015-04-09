% This is PUMA3d.M, a 3D Matlab Kinematic model of a Puma robot located
% in the robotics lab of Walla Walla University.
% The file uses CAD data converted to Matlab using cad2matdemo.m, which 
% is located on the Mathworks central file exchange.
%
% This file is still being developed, for the latest version check the
% Mathworks central file exchange.
%
% Todo list:
% 1) optimize pumaANI, lots of stuff in loop that needs help.
% 2) move x, y, and z position to end effecter, not link 6 origin.
% 3) Toggle kinematics buttons on/off with inverse kinematics button.
% 4) Make this work with real time inverse kinematics.
% 5) Make the track on and off option better.
% 6) add other things that makes this program fun.
% 7) check for noplots and nogos
% 8) add some better "demos" for the button
% 9) Fix problem of more than one robot window.
%

function puma3d
% GUI kinematic demo for the Puma Robot.
% Robot geometry uses the CAD2MATDEMO code in the Mathworks file exchange
%

addpath gui/

init_arm

fig_1 = getappdata(0, 'fig_1');
%
% Create the push buttons: pos is: [left bottom width heigHEIGHT]
uicontrols = {};
setappdata(0, 'uicontrols', uicontrols);

uicontrols.demo = uicontrol(fig_1,'String','Demo','callback',@demo_button_press,...
    'Position',[20 5 60 20]);

uicontrols.rnd_demo= uicontrol(fig_1,'String','Random Move','callback',@rnd_demo_button_press,...
    'Position',[100 5 80 20]);

uicontrols.clr_trail= uicontrol(fig_1,'String','Clr Trail','callback',@clr_trail_button_press,...
    'Position',[200 5 60 20]);

uicontrols.home= uicontrol(fig_1,'String','Home','callback',@home_button_press,...
    'Position',[280 5 70 20]);

uicontrols.create_ball = uicontrol(fig_1,'String','Create Ball','callback',@create_ball_button_press,...
    'Position', [370 5 80 20]);

% 
% Kinematics Panel
%
kin_panel = {};

K_p = uipanel(fig_1,...
    'units','pixels',...
    'Position',[20 45 265 200],...
    'Title','Kinematics','FontSize',11);
kin_panel.uipanel = K_p;
kin_panel.theta = [{}, {}, {}, {}, {}, {}];
%
%     Angle    Range                Default Name
%     Theta 1: 320 (-160 to 160)    90       Waist Joint  
%     Theta 2: 220 (-110 to 110)   -90       ShouLEFTer Joint
%     Theta 3: 270 (-135 to 135)   -90       Elbow Joint    
%     Theta 4: 532 (-266 to 266)     0       Wrist Roll
%     Theta 5: 200 (-100 to 100)     0       Wrist Bend  
%     Theta 6: 532 (-266 to 266)     0       Wrist Swivel

% offset to define the "home" position as UP.
home_pos = [90, -90, -90, 0, 0, 0];
setappdata(0, 'home_pos', home_pos);
min_pos = [-160, -110, -350, -266, -100, -266];
setappdata(0, 'min_pos', min_pos);
max_pos = [160, 110, 350, 266, 100, 266];
setappdata(0, 'max_pos', max_pos);

LEFT = 2; % Left
HEIGHT = 18;  % Height
BOTTOM = 156; % Bottom

%%  GUI buttons for Theta.  pos is: [left bottom width height]
for i=1:6
    kin_panel.theta(i).text = uicontrol(K_p,'style','text',...
        'String', ['T' int2str(i)],...
        'Position',[LEFT BOTTOM 20 HEIGHT]); % L, B, W, H
    kin_panel.theta(i).edit = uicontrol(K_p,'style','edit',...
        'String', 0,...
        'callback',@edit_button_press,...
        'Position',[LEFT+20 BOTTOM 40 HEIGHT]); % L, B, W, H
    kin_panel.theta(i).min = uicontrol(K_p,'style','text',...
        'String', int2str(min_pos(i)),...
        'Position',[LEFT+60 BOTTOM+1 35 HEIGHT-4]); % L, from bottom, W, H
    kin_panel.theta(i).slider = uicontrol(K_p, 'style', 'slider',...
        'Max', max_pos(i), 'Min', min_pos(i), 'Value', 0,...
        'SliderStep', [0.05 0.2],...
        'callback', @slider_button_press,...
        'Position', [LEFT+95 BOTTOM 120 HEIGHT]);
    kin_panel.theta(i).max = uicontrol(K_p,'style','text',...
        'String', int2str(max_pos(i)),...
        'Position',[LEFT+215 BOTTOM+1 35 HEIGHT-4]); % L, B, W, H
    BOTTOM = BOTTOM - 30;
end
setappdata(0, 'kin_panel', kin_panel);
% rmpath gui/
end

% Finally.