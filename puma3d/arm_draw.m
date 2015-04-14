function arm_draw
    arm = getappdata(0, 'arm');
    
    set(arm.patch_h(1), 'faces', arm.link_data.s1.F1, 'vertices', arm.link1(:,1:3));
    set(arm.patch_h(2), 'faces', arm.link_data.s2.F2, 'vertices', arm.link2(:,1:3));
    set(arm.patch_h(3), 'faces', arm.link_data.s3.F3, 'vertices', arm.link3(:,1:3));
    set(arm.patch_h(4), 'faces', arm.link_data.s4.F4, 'vertices', arm.link4(:,1:3));
    set(arm.patch_h(5), 'faces', arm.link_data.s5.F5, 'vertices', arm.link5(:,1:3));
    set(arm.patch_h(6), 'faces', arm.link_data.s6.F6, 'vertices', arm.link6(:,1:3));
    set(arm.patch_h(7), 'faces', arm.link_data.s7.F7, 'vertices', arm.link7(:,1:3));
    set(arm.patch_h(8), 'faces', arm.link_data.A1.Fa, 'vertices', arm.link_data.A1.Va(:,1:3));
    set(arm.patch_h(9), 'XData', arm.trail(1, :), 'YData', arm.trail(2, :), 'ZData', arm.trail(3, :));
    
    setappdata(0, 'arm', arm);
end