function print_valfunc(J,k)

    a = cell2mat(keys(J));
    b = cell2mat(values(J));
    b = b(1,:);
    [a' b' ]';
    c = [a' b' ]';
    v = cell2mat(values(J));
    v = v(2,:);
    
    x = c(1,:)';
    y = c(2, :)';
    z = v';    
    xlin = linspace(min(x),max(x),33);
    ylin = linspace(min(y),max(y),33);
    [X,Y] = meshgrid(xlin,ylin);
    f = scatteredInterpolant(x,y,z);
    Z = f(X,Y);
    %figure
    mesh(X,Y,Z) %interpolated
    title(sprintf('Value Fuction Iter: %d ', k));
%     figure
% colormap hsv
% surf(X,Y,Z,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','gouraud')
% 
% % daspect([5 5 1])
% 
% 
% axis tight
% view(0,0)
% camlight left

    
    axis tight;
%     plot3(x,y,z,'.','MarkerSize',15) %nonuniform
    
% 	surf(V,'EdgeColor','none')
    
	if(k>=0)
		temps = sprintf('i%d_vfunc.png',k);
		print('-dpng',temps); 
	end

end