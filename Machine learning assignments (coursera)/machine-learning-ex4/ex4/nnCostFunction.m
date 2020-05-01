function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
X = [ones(m, 1) X];
a1 = X;
z2 = a1 * Theta1';
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2];
z3 = a2 * Theta2';
h = sigmoid(z3);

sum_inner = 0;
sum_inner_r1 = 0;
r1_term = 0;
sum_inner_r2 = 0;
r2_term = 0;
Y = eye(num_labels)(y,:);
for i=1:m
  for k=1:num_labels
    h(i,k) = -1 * Y(i,k) * log(h(i,k)) - (1-Y(i,k)) * log(1-h(i,k));
    sum_inner += h(i,k);
  endfor
  J += sum_inner;
  sum_inner = 0; 
endfor
J = (1/m) * J ;
Theta_1 = Theta1(:, 2:end);

for j=1:size(Theta_1,1);
  for k=1:size(Theta_1,2)
    sum_inner_r1 += (Theta_1(j,k) ^ 2);
  endfor
  r1_term += sum_inner_r1;
  sum_inner_r1 = 0;
endfor
Theta_2 = Theta2(:, 2:end);
for j=1:size(Theta_2,1);
  for k=1:size(Theta_2,2)
    sum_inner_r2 += (Theta_2(j,k) ^ 2);
  endfor
  r2_term += sum_inner_r2;
  sum_inner_r2 = 0;
endfor
J = J + (lambda/(2*m)) * (r1_term + r2_term);

%backpropagation
for i=1:m
  a1 = X(i,:);
  z2 = Theta1 * a1';
  a2 = sigmoid(z2);
  a2 = [1; a2];
  z2=[1; z2];
  z3 = Theta2 * a2;
  a3 = sigmoid(z3);
  gamma_l = a3 - (Y(i,:))';
  gamma_hidden = Theta2' * gamma_l .* sigmoidGradient(z2);
  gamma_hidden = gamma_hidden(2:end);
  Theta2_grad = Theta2_grad + gamma_l * a2';
  Theta1_grad = Theta1_grad + gamma_hidden * a1;
endfor
Theta2_grad = (1/m) * Theta2_grad;
Theta1_grad = (1/m) * Theta1_grad;


Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + ((lambda/m) * Theta1(:, 2:end)); 

Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + ((lambda/m) * Theta2(:, 2:end)); 


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
