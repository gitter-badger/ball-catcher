function delete_balls


balls = getappdata(0, 'balls');
  [sphere_x, sphere_y, sphere_z] = sphere;
  for i=length(balls):-1:1
      
    set(balls{i}.handler, ...
            'XData', sphere_x * balls{i}.radius + 0, ...
            'YData', sphere_y * balls{i}.radius + 0, ...
            'ZData', sphere_z * balls{i}.radius + 0 );
    balls(i)=[];
    setappdata(0, 'balls', balls);
    
    
 end
end