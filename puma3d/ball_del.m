function ball_del(ids)
    balls = getappdata(0, 'balls');

    if nargin == 0

        ids =1:length(balls);
    end
    
    ids = sort(ids); % Delete the last id first ... else, array collapses on itself
    
    for i=length(ids):-1:1
        delete(balls(ids(i)).handler);
        balls(ids(i))=[];

    end
    setappdata(0, 'balls', balls);
end