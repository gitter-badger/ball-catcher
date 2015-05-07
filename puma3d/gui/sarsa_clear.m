function sarsa_clear(h, dummy)
    
    weights_sarsa = zeros(3, 8);
    save('./weights_sarsa.mat', 'weights_sarsa');
    
    sarsa = getappdata(0, 'sarsa');
    sarsa = {};
    setappdata(0, 'sarsa', sarsa);
    
end