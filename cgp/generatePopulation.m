function [ individuals ] = generatePopulation( popSize, funcIn, inputs, func, layers, nodes )
%GENERATEPOPULATION Summary of this function goes here
%   Detailed explanation goes here
%% Generates a population with the contraints for CGP
% First layer is only inputs.
% Nodes are only allowed to connect to lower layers.
% Last layer is only output.

for k = 1:popSize
    index = 3;
    % input layer
    individuals(1,:,k) = [0 zeros(1,funcIn)];
    individuals(2,:,k) = [0 zeros(1,funcIn)];
    % first layer
    for j = 1:nodes
        individuals(index,:,k) = [randi(inputs,1,funcIn) randi(size(func))];
        index = index+1;
    end
    % layer 2-n
    for i = 1:layers-1
        for j = 1:nodes
            individuals(index,:,k) = [randi(inputs+i*nodes,1,funcIn) randi(size(func))];
            index = index+1;
        end
    end
    % output layer
    output = randi(layers*nodes);
    individuals(index,:,k) = [output zeros(1,funcIn)];
end


end

