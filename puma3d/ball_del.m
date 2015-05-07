function ball_del(id)
    balls = getappdata(0, 'balls');
    
    if nargin == 0
        for i=1:length(balls)
            delete(balls{i}.handler);
            balls{i}=[];
        end
    else
        delete(balls{id}.handler);
        balls{id}=[];
    end
    setappdata(0, 'balls', balls);
end