function y = softmax(x)
    % Subtract the maximum value for numerical stability
    x = x - max(x, [], 2);
    
    % Compute the exponentials of each element
    exp_x = exp(x);
    
    % Sum the exponentials along the row (for each sample)
    sum_exp_x = sum(exp_x, 2);
    
    % Divide each exponential by the sum of exponentials
    y = exp_x ./ sum_exp_x;
end
