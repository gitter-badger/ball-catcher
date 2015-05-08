function [sortedsuccesspaths, sortedreturns] = print_tree(rrt,k,J,puddle, alpha, gamma, knn)
	points = [rrt.state]; 
    %figure
	plot(points(1,:),points(2,:),'r.');
    plot(0,0,'w. ');
    plot(0,50,'w. ');
    plot(50,0,'w. ');
    plot(50,50,'w. ');
    len = 0;
    title(sprintf('RRT: Iter: %d alpha: %f gamma: %f %d-nn', k));
	hold on;
    
    for i = 1: numel(puddle)
        t = linspace(0,2*pi);plot(puddle(i).x+puddle(i).r*cos(t), puddle(i).y+puddle(i).r*sin(t));
        
    end
    
    a = cell2mat(keys(J));
    b = cell2mat(values(J));
    if( numel(a) > 0)
        b = b(1,:);
        [a' b' ]';
        c = [a' b' ]';
        v = cell2mat(values(J));
        v = v(2,:);
        for i = 1 : numel(v)
            if( v(i) > 0)
                plot( c(1,i), c(2,i), 'm.' );
            else if v(i) == 0
                plot( c(1,i), c(2,i), 'y.' );
                else
                    plot( c(1,i), c(2,i), 'k.' );
                end
            end
        end
    end
    
    
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
             
            
         
            awesomepaths = {};
            awesomerewards = [];
            optpath = [];
            optreward = [];
            
            maxi = i;
            blehstate = rrt(maxi).state;
            
            while (~isempty(rrt(maxi)))
                optpath = [optpath rrt(maxi).state];
                
                optreward = [optreward  rrt(maxi).rew];
%                 len = len + norm(rrt(maxi).state - rrt(rrt(maxi).parent).state);
                if( ~isempty(rrt(maxi).parent))
                    maxi = rrt(maxi).parent;
                else 
                    break;
                end
                
            end
            if( blehstate(1) > 45 && blehstate(2) > 45)
                display('saving path!');    
                awesomepaths{end+1} = {optpath};
                awesomerewards(end+1) = sum(optreward);
                
            end
            if(numel(optpath) > 0)
                plot(optpath(1,:),optpath(2,:),'g-','LineWidth',0.5);
            end
        end
   end
    
    sortedsuccesspaths = awesomepaths;
    [sortedreturns, blaidx] = sort(awesomerewards);
    for i = 1: numel(blaidx)
        sortedsuccesspaths{i} = awesomepaths{blaidx(i)};
    end
    
   
   
   hold off;
   if(k>=0)
	temps = sprintf('i%d_rrtl%0.3falp%0.4fgam%0.4f.png',k, rand(1),alpha,gamma);
	print('-dpng',temps); 
   end
end