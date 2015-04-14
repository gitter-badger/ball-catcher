function ball_del()
    balls = getappdata(0, 'balls');
    delete(balls);
    rmappdata(0, 'balls');
end