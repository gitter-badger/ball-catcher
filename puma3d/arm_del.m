function arm_del()
    arm = getappdata(0, 'arm');
    delete(arm);
    rmappdata(0, 'arm');
end