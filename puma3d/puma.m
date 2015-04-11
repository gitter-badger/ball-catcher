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

function puma
    % GUI kinematic demo for the Puma Robot.
    % Robot geometry uses the CAD2MATDEMO code in the Mathworks file exchange
    %
    
    addpath gui/
    
    % Creates the "arm" structure with :
    % link_data, home_pos, max_pos, min_pos, a2, a3, d3, d4, theta
    arm_init;
    
    % uses "arm.theta" to make :
    % link1, link2, link3, link4, link5, link6, link7
    arm_calc_links;
    
    % Creates the "fig" figure and plots basic links/axes etc
    % Adds "arm.trail" to arm structure
    % Creates kin_panel and uicontrols also.
    % draws the patches which will be used for the arm also
    fig_init;
    
    % Uses the "arm.link_data" and "arm.linkX" to make
    % patch handlers and saved in "arm.patch_h" Also initializes "trail"
    arm_draw;

    % rmpath gui/
end

% Finally.