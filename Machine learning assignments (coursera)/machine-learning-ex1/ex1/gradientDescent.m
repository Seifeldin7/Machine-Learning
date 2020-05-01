function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESCENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %
    sum0 =0;
    sum1 =0;
    for i = 1:m
      h =   theta(1) + theta(2).*X(i,2);
      sum0 += h - y(i);
      sum1 += (h - y(i)).*X(i,2);
    endfor
    theta(1) = theta(1) - (alpha/m) * sum0;
    theta(2) = theta(2) - (alpha/m) * sum1;
    




    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCost(X, y, theta)

end

end
