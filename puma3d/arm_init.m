% Load link data from the mat file provided (linksdata.mat)
% Use forward kinematics to place the robot in a specified
% home configuration.
% Setup the Figure data and create a new figure for the GUI
%
%     Angle    Range                Default Name
%     Theta 1: 320 (-160 to 160)    90       Waist Joint  
%     Theta 2: 220 (-110 to 110)   -90       ShouLEFTer Joint
%     Theta 3: 270 (-135 to 135)   -90       Elbow Joint    
%     Theta 4: 532 (-266 to 266)     0       Wrist Roll
%     Theta 5: 200 (-100 to 100)     0       Wrist Bend  
%     Theta 6: 532 (-266 to 266)     0       Wrist Swivel

function arm_init
    % Load all the link data from file linksdata.mat.
    % This data comes from a Pro/E 3D CAD model and was made with cad2matdemo.m
    % from the file exchange.  All link data manually stored in linksdata.mat
    arm = {};
    
    arm.link_data = load('linksdata.mat', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 'A1');

    % offsets to define the "home" position as UP & ranges.
    arm.home_pos = [90, -90, -90, 0, 0, 0];
    arm.min_pos = [-160, -110, -350, -266, -100, -266];
    arm.max_pos = [160, 110, 350, 266, 100, 266];

    % Some constants for the arm. Not sure for what. Used in calculations
    arm.a2 = 650;
    arm.a3 = 0;
    arm.d3 = 190;
    arm.d4 = 600;

    % The 'home' position in angles, for the start
    arm.theta = arm.home_pos;
    
    setappdata(0, 'arm', arm);
end