function arm_draw
    arm = getappdata(0, 'arm');
    for i=1:size(arm,2)
    set(arm(i).patch_h(1), 'faces', arm(i).link_data.s1.F1, 'vertices', arm(i).link1(:,1:3));
    set(arm(i).patch_h(2), 'faces', arm(i).link_data.s2.F2, 'vertices', arm(i).link2(:,1:3));
    set(arm(i).patch_h(3), 'faces', arm(i).link_data.s3.F3, 'vertices', arm(i).link3(:,1:3));
    set(arm(i).patch_h(4), 'faces', arm(i).link_data.s4.F4, 'vertices', arm(i).link4(:,1:3));
    set(arm(i).patch_h(5), 'faces', arm(i).link_data.s5.F5, 'vertices', arm(i).link5(:,1:3));
    set(arm(i).patch_h(6), 'faces', arm(i).link_data.s6.F6, 'vertices', arm(i).link6(:,1:3));
    set(arm(i).patch_h(7), 'faces', arm(i).link_data.s7.F7, 'vertices', arm(i).link7(:,1:3));
    
    set(arm(i).patch_h(8), 'faces', arm(i).link_data.A1.Fa, 'vertices', arm(i).link_data.A1.Va(:,1:3));
    set(arm(i).patch_h(9), 'XData', arm(i).trail(1, :), 'YData', arm(i).trail(2, :), 'ZData', arm(i).trail(3, :));
    end
    setappdata(0, 'arm', arm);
end