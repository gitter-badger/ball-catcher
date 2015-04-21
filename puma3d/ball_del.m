function ball_del()
    balls = getappdata(0, 'balls');
    length(balls)
    for i =1:length(balls)
        delete(balls{i}.handler);
    end
    rmappdata(0, 'balls');
end