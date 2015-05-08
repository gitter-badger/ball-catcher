function value = getNNvalue(point, k , J ) 
    value = 0;
    k = 1;
    if(numel(keys(J)) == 0) 
        value = 0;
        return;
    end
    checked = false;
    i = 1;
    
    keyset = [point(1)];
    if isKey(J, keyset)
       i;
%        display('actually found it!');
       value = J(point(1));
       
       value = value(2);
       return;
    else
        
        keyset = cell2mat(keys(J));
        valueset = cell2mat(values(J));
        valueset = valueset(1,:);
        matJ = [keyset' valueset']';
        [uselessinfo,idx] = sort(sum((matJ(:,:)-repmat(point,1,numel(keys(J)))).^2));%calc distances to all points in the rrt
        sumj = 0;
        vals = cell2mat(values(J));
        vals = vals(2,:);
        if( length(idx) < k) 
            k = length(idx);
        end
        for iter12 = 1: k
            sumj = sumj + vals(idx(iter12));

        end
        if(k ~= 0) 
            sumj = sumj/k; 
        end
        value = sumj;
        if abs(value) < 0.0001
            value = 0;
        end
    end
    
end