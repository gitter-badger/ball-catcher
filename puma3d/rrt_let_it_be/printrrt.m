function printrrt(rrt,k)
    points = [rrt.state];
    
     figure;
	plot3(points(1,:),points(2,:), points(3,:), 'r.');
    len = 0;
    title(sprintf('RRT: %d', k));
	hold on;

   for i = 1:numel(rrt)
        % LEAF CHECKER!      
        i;
        isLeaf = 1;
        
        for j = 1:numel(rrt)
           par = rrt(j).parent;
           if(isempty(rrt(j).parent))
              %j, rrt(j).state, 'no parent for me :('
            % CHECK ANOTHER!
              continue;
           end
           j;
           
           if i == par
            %i , 'is a parent', par
            isLeaf = 0; 
     %NOT A LEAF!!
            break;
           end
        end %j for loop
        
        if isLeaf == 1
    % IS A FUCKING LEAF!
             % for this trajectory do the td updates
            optpath = [];
            maxi = i;
            while (~isempty(rrt(maxi)))
                optpath = [optpath rrt(maxi).state];
%                 len = len + norm(rrt(maxi).state - rrt(rrt(maxi).parent).state);
                if( ~isempty(rrt(maxi).parent))
                    maxi = rrt(maxi).parent;
                else 
                    break;
                end
                
            end
            optpath;
            if(numel(optpath) > 0)
                plot3(optpath(1,:),optpath(2,:), optpath(3,:),'g-','LineWidth',0.5);
            end
        end
   end
   
   hold off;
   if(k>=0)
	temps = sprintf('i%d_rrtl%f',k, rand(1));
	print('-dpng',temps); 
   end
end