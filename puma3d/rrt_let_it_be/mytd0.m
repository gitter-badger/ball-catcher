function [J] = mytd0(rrt,J, alpha, gamma, k )  %it needs to return a value function!
%	data = csvread(file);
%	s = data(:,1:2);
%	s_next = data(:,3:4);
%	r = data(:,5);

    
    %rrt is a graph with state, parent and rew
	for i = 1:numel(rrt)
%     disp(sprintf('point (%g %g): reward %g', rrt(i).state, rrt(i).rew  ));
        
  % LEAF CHECKER!      
        %check if the current element is not there in any parent field of
        %the rrt 
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
            p = i;
           while p ~= 1
               
               curr = rrt(p).parent;
               next = p;
               r = rrt(p).rew;
               
               if( curr > numel(rrt))
                   display(sprintf('how can a state be more than quantity'));
                   break;
               end
               
                     
               x_curr = rrt(curr).state;
               y_curr = x_curr(2);
               x_curr = x_curr(1);
               
               
               x_next = rrt(next).state;
               y_next = x_next(2);
               x_next = x_next(1);
               
               
               
               
               if ~isKey(J, x_curr)
                   val = getNNvalue(rrt(curr).state, 1, J);
%                    display(sprintf('curr %0.4f %0.4f : %0.5f', x_curr, y_curr, val));
                   %put it in J
                   if( abs(val) < 0.0001)
                       val = 0;
                   end
                   J(x_curr) = [y_curr;val];
               end
               
               if ~isKey(J, x_next)

                   val = getNNvalue(rrt(next).state,1,J);
                   if( abs(val) < 0.0001)
                       val = 0;
                   end
                   if(x_next > 90 && y_next > 90) 
                      val = 100; 
                   end
%                    display(sprintf('next %0.4f %0.4f : %0.5f', x_next, y_next, val));
                   J(x_next) = [y_next;val]; 
                
               end
               
               j_curr = J(x_curr);
               j_curr = j_curr(2);
               j_next = J(x_next);
               j_next = j_next(2);
               
               
               j_curr = (1 - alpha) *j_curr + alpha* (r + gamma * j_next ); 
%                display(sprintf('set %f %f to %f',x_curr, y_curr, j_curr));
               J(x_curr) = [y_curr;j_curr];
               p = rrt(p).parent;
             
            end
    
   end
    end

   end