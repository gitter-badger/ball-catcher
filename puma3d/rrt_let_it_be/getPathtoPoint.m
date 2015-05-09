function [optpath] =  getPathtoPoint(rrt, any_point)
     for i = 1:numel(rrt)
        if ~(rrt(i).state == any_point)
               continue;
        end
            optpath = [];
            maxi = i; 
            
            while (~isempty(rrt(maxi)))
                optpath = [optpath rrt(maxi).state];
                
                if( ~isempty(rrt(maxi).parent))
                    maxi = rrt(maxi).parent;
                else 
                    break;
                end
                
            end
            
%             if(numel(optpath) > 0)
%                 plot(optpath(1,:),optpath(2,:),'g-','LineWidth',0.5);
%             end
        end
end
    