% Load link data from the mat file provided (linksdata.mat)
% Use forward kinematics to place the robot in a specified
% home configuration.
% Setup the Figure data and create a new figure for the GUI

function init_arm
    % Load all the link data from file linksdata.mat.
    % This data comes from a Pro/E 3D CAD model and was made with cad2matdemo.m
    % from the file exchange.  All link data manually stored in linksdata.mat
    link_data = load('linksdata.mat', 's1', 's2', 's3', 's4', 's5', 's6', 's7', 'A1');

    % Place the robot link 'data' in a storage area
    setappdata(0, 'link_data', link_data);

    set(0, 'Units', 'pixels')
    dim = get(0, 'ScreenSize');

    fig_1 = figure('doublebuffer','on','Position',[0,35,dim(3)-200,dim(4)-110],...
        'MenuBar','none','Name',' 3D Puma Robot Graphical Demo',...
        'NumberTitle','off');
    setappdata(0, 'fig_1', fig_1);
    hold on;
    %light('Position',[-1 0 0]);
    light;                       % add a default light
    daspect([1 1 1]);            % Setting the aspect ratio
    view(135, 25);               % Set viewpoint (azimuth, elevation)
    xlabel('X'); 
    ylabel('Y'); 
    zlabel('Z');
    title('PUMA 762');

    % Make sure it axes are scaled correctly
    axis([-1500 1500 -1500 1500 -1120 1500]);
    % Plot lines at the corners of the cube defines by aboze axes
    plot3([-1500,1500],[-1500,-1500],[-1120,-1120],'k')
    plot3([-1500,-1500],[-1500,1500],[-1120,-1120],'k')
    plot3([-1500,-1500],[-1500,-1500],[-1120,1500],'k')
    plot3([-1500,-1500],[1500,1500],[-1120,1500],'k')
    plot3([-1500,1500],[-1500,-1500],[1500,1500],'k')
    plot3([-1500,-1500],[-1500,1500],[1500,1500],'k')

    % Get all link data from the app
    link_data = getappdata(0,'link_data');
    
    a2 = 650;
    a3 = 0;
    d3 = 190;
    d4 = 600;
    Px = 5000;
    Py = 5000;
    Pz = 5000;

    % The 'home' position in angles, for the start
    t1 = 90;
    t2 = -90;
    t3 = -90;
    t4 = 0;
    t5 = 0;
    t6 = 0;

    % Forward Kinematics using T-Matrix
    T_01 = tmat(0, 0, 0, t1);
    T_12 = tmat(-90, 0, 0, t2);
    T_23 = tmat(0, a2, d3, t3);
    T_34 = tmat(-90, a3, d4, t4);
    T_45 = tmat(90, 0, 0, t5);
    T_56 = tmat(-90, 0, 0, t6);

    % Each (link frame) to (base frame) transformation
    T_02 = T_01*T_12;
    T_03 = T_02*T_23;
    T_04 = T_03*T_34;
    T_05 = T_04*T_45;
    T_06 = T_05*T_56;

    % Actual transformed vertex data of robot links
    Link1 = link_data.s1.V1;
    Link2 = (T_01*link_data.s2.V2')';
    Link3 = (T_02*link_data.s3.V3')';
    Link4 = (T_03*link_data.s4.V4')';
    Link5 = (T_04*link_data.s5.V5')';
    Link6 = (T_05*link_data.s6.V6')';
    Link7 = (T_06*link_data.s7.V7')';

    % points are no fun to watch, make it look 3d by making patches
    L1 = patch('faces', link_data.s1.F1, 'vertices', Link1(:,1:3));
    L2 = patch('faces', link_data.s2.F2, 'vertices', Link2(:,1:3));
    L3 = patch('faces', link_data.s3.F3, 'vertices', Link3(:,1:3));
    L4 = patch('faces', link_data.s4.F4, 'vertices', Link4(:,1:3));
    L5 = patch('faces', link_data.s5.F5, 'vertices', Link5(:,1:3));
    L6 = patch('faces', link_data.s6.F6, 'vertices', Link6(:,1:3));
    L7 = patch('faces', link_data.s7.F7, 'vertices', Link7(:,1:3));
    A1 = patch('faces', link_data.A1.Fa, 'vertices', link_data.A1.Va(:,1:3));
    Tr = plot3(0, 0, 0, 'b.'); % holder for trail paths
    
    setappdata(0,'patch_h', [L1, L2, L3, L4, L5, L6, L7, A1, Tr])
    
    setappdata(0, 'xtrail', 0); % used for trail tracking.
    setappdata(0, 'ytrail', 0); % used for trail tracking.
    setappdata(0, 'ztrail', 0); % used for trail tracking.
    
    set(L1, 'facec', [0.717,0.116,0.123]);
    set(L1, 'EdgeColor','none');
    set(L2, 'facec', [0.216,1,.583]);
    set(L2, 'EdgeColor','none');
    set(L3, 'facec', [0.306,0.733,1]);
    set(L3, 'EdgeColor','none');
    set(L4, 'facec', [1,0.542,0.493]);
    set(L4, 'EdgeColor','none');
    set(L5, 'facec', [0.216,1,.583]);
    set(L5, 'EdgeColor','none');
    set(L6, 'facec', [1,1,0.255]);
    set(L6, 'EdgeColor','none');
    set(L7, 'facec', [0.306,0.733,1]);
    set(L7, 'EdgeColor','none');
    set(A1, 'facec', [.8,.8,.8],'FaceAlpha',.25);
    set(A1, 'EdgeColor','none');
    
    setappdata(0,'ThetaOld', [90,-90,-90,0,0,0]);
end