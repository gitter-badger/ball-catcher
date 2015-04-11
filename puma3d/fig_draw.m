function fig_draw
    arm = getappdata(0, 'arm');
    
    % points are no fun to watch, make it look 3d by making patches
    % Note : 1-7 are links, 8 is area ? 9 is trail
    arm.patch_h(1) = patch('faces', arm.link_data.s1.F1, 'vertices', arm.link1(:,1:3));
    arm.patch_h(2) = patch('faces', arm.link_data.s2.F2, 'vertices', arm.link2(:,1:3));
    arm.patch_h(3) = patch('faces', arm.link_data.s3.F3, 'vertices', arm.link3(:,1:3));
    arm.patch_h(4) = patch('faces', arm.link_data.s4.F4, 'vertices', arm.link4(:,1:3));
    arm.patch_h(5) = patch('faces', arm.link_data.s5.F5, 'vertices', arm.link5(:,1:3));
    arm.patch_h(6) = patch('faces', arm.link_data.s6.F6, 'vertices', arm.link6(:,1:3));
    arm.patch_h(7) = patch('faces', arm.link_data.s7.F7, 'vertices', arm.link7(:,1:3));
    arm.patch_h(8) = patch('faces', arm.link_data.A1.Fa, 'vertices', arm.link_data.A1.Va(:,1:3));
    arm.patch_h(9) = plot3(0, 0, 0, 'b.'); % holder for trail paths
    
    set(arm.patch_h(1), 'facec', [0.717, 0.116, 0.123]);
    set(arm.patch_h(1), 'EdgeColor', 'none');
    set(arm.patch_h(2), 'facec', [0.216, 1, .583]);
    set(arm.patch_h(2), 'EdgeColor', 'none');
    set(arm.patch_h(3), 'facec', [0.306, 0.733, 1]);
    set(arm.patch_h(3), 'EdgeColor', 'none');
    set(arm.patch_h(4), 'facec', [1, 0.542, 0.493]);
    set(arm.patch_h(4), 'EdgeColor', 'none');
    set(arm.patch_h(5), 'facec', [0.216, 1, .583]);
    set(arm.patch_h(5), 'EdgeColor', 'none');
    set(arm.patch_h(6), 'facec', [1, 1, 0.255]);
    set(arm.patch_h(6), 'EdgeColor', 'none');
    set(arm.patch_h(7), 'facec', [0.306, 0.733, 1]);
    set(arm.patch_h(7), 'EdgeColor', 'none');
    set(arm.patch_h(8), 'facec', [.8, .8, .8], 'FaceAlpha', .25);
    set(arm.patch_h(8), 'EdgeColor', 'none');
    
    setappdata(0, 'arm', arm);
end