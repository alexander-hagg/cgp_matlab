function [winner, eliteFitness] = CGP_main(targetFunc)
%Cartesian Genetik Programming with a Genetic algorithm
%Implementation by Daniel Brilz
%% Define CGP settings
% define operator names
func(1,:) = {'mult', 'add', 'sub','pow','div'};
% define arguments accepted by functions
funcProp = [2,2,2,2,2,2];

% target function (for testing purposes)
% targetFunc = 'x*y';
% targetFunc = 'x+y^2';
% targetFunc = 'sin(x)';

% number of individuals
popSize = 10;

% crossover rate
rateXover = 0.9;

% number of inputs
inputs = 2;

% number of turns to evaluate the fitness
fitnessTurns = 2;

% max number of inputs for operators
funcIn = max(funcProp);

% number of nodes per layer
nodes = 5;

% number of layers
layers = 5;

% number of output nodes
out = 1;

% mutation rate
rateMut = 1/(layers*nodes+1);

% maximal amout of generations
maxGenerations = 1000;

%% Generate initial population
% Generates a node array with the settings parameters to represent the
% initial population.
%
% Representation of the columns of the array:
%
% * col 1-n1 = random input src
% * col n = random function index

individuals = generatePopulation(popSize, funcIn, inputs, func, layers, nodes);
%% Turn for each Generation

for gen = 1:maxGenerations
    %% Build the function strings of the individuals
    % Builds the function that each individual is reprenting to be
    % evaluated later
    
    for k = 1:popSize
        tempString = genFunc2(func, funcProp, individuals(:,:,k), individuals(size(individuals,1)));
        if(iscell(tempString))
            individualFunc(k) = tempString;
        else
            individualFunc(k) = mat2cell(tempString,1);
        end
    end
    %% Calculate the fitness
    % evaluate with #fitnessTurns(>1) sets of variables to make fitness value
    % more reliable.
    % Fitness contains the error/difference to the result evaluated with
    % the target function
    
    fitness = zeros(1,popSize);
    for i = 1:fitnessTurns
        x = randi(20)-10;
        y = randi(20)-10;
        for k = 1:popSize
            fitness(k) = fitness(k) + evalSim(individualFunc(k), targetFunc, x,y);
        end
    end
    
    %% Elitism
    % Save recent elite invidiual and find the elite individual of the
    % current generation. Save the elite fitness to the elite history.
    
    if(gen > 1)
        oldElite = eliteIndividual;
    end
    eliteIndividual = individuals(:,:,find(fitness <= min(fitness),1));
    eliteFitness(gen) = min(fitness);
    
    
    %% Creating the next generation
    % Create a tournament to determine the matchup for a tournament
    % selection
    matchupA = randi(popSize,popSize,2);
    matchupB = randi(popSize,popSize,2);
    %%
    % Determine the winners of each match up
    winnerA = zeros(popSize,1);
    winnerB = zeros(popSize,1);
    
    for i= 1:popSize
        if(fitness(matchupA(i,1)) <= fitness(matchupA(i,2)))
            winnerA(i) = matchupA(i,1);
        else
            winnerA(i) = matchupA(i,2);
        end
        if(fitness(matchupB(i,1)) <= fitness(matchupB(i,2)))
            winnerB(i) = matchupB(i,1);
        else
            winnerB(i) = matchupB(i,2);
        end
    end
    
    %% Perform Crossover
    % Applied crossover mechanics:
    %
    % # Find a random cut point.
    % # First half to cut point belongs to winnerA
    % # Second half from cut to end belongs to winnerB
    % # Concatenate both 'halfs' to generate the new individual
    
    doXover = (rand(popSize,1) < rateXover);
    
    for i = 1:popSize
        if(doXover(i) == 1)
            cut = randi(nodes*layers+1,1,1)+inputs;
            newPop(:,:,i) = vertcat(individuals(1:cut,:,winnerA(i)), individuals(cut+1:end,:,winnerB(i)));
        else
            newPop(:,:,i) = individuals(:,:,winnerA(i));
        end
    end
    
    %% Perform Mutation
    % Applied mutation mechnics:
    %
    % # Swap current operator to a new random operator
    % # Find all new random sources for this node
    
    mutation = rand(layers*nodes+1,popSize) < rateMut;
    for k = 1:popSize
        for i = 1:layers*nodes+1
            if(mutation(i,k))
                currentLayer = ceil(i/nodes)-1;
                for j = 1:funcIn
                    %                     disp(i)
                    src = randi((currentLayer*nodes)+2);
                    newPop(i+2,j,k) = src;
                end
                newPop(i+2,funcIn+1,k) = randi(size(func));
            end
        end
    end
    
    %% Visualization
    % optinal for testing purposes
    
    %     figure(1);
    %     plot(eliteFitness);hold on;
    %     title('Fitness')
    %     xlabel('Generations');ylabel('Fitness (rmse)');
    %
    % %     plot(avgFitness);
    %     hold off;
    %     pause(0.0000000000000000000000000001);
    
    
    %% Break condition
    % End CGP and return resolution if fitness is zero in three following
    % generations and its caused by the same elite individual
    
    if(gen >3)
        if((eliteFitness(gen) <0.1 && eliteFitness(gen-1) <0.1 && eliteFitness(gen-2) <0.1 && isequal(oldElite, eliteIndividual))|| gen == maxGenerations)
            winner = genFunc2(func, funcProp, eliteIndividual(:,:), individuals(size(individuals,1)));
            %             disp(winner);
            %             x = [1:100;1:100];
            %             y = [1:100,1:100];
            %             [x,y] = meshgrid(0:0.25:100);
            %             for x = 1:100
            %                for y = 1:100
            %                    z_pred(x,y) = eval(cell2mat(winner));
            %                    z_real(x,y) = eval(targetFunc);
            %                end
            %             end
            %             figure(2);
            % %             mesh(eval(cell2mat(winner)));
            %             mesh(z_pred);
            %             title(winner);
            %
            %             figure(3);
            % %             mesh(eval(targetFunc));
            %             mesh(z_real);
            %             title(['targetFunction: ' targetFunc]);
            %             figure(4);
            %             imagesc(genotype)
            %             title('Genotypes of the best individual');
            %             xlabel('Generations');ylabel('Genotypes (inputs + function)');
            %             colorbar;
            % %             colormap('hot');
            break;
        end
    end
    
    %% Elitism insert
    % Insert the elite individual of last generation in the new generation
    % at the first spot.
    
    newPop(:,:,1) = eliteIndividual;
    
    individuals = newPop;
    
    %% Population Flush
    % Prevent population getting stuck in a local minimum.
    % Sometimes GCP gets stuck with input values as local minimum.
    % This happens mostly when evaluted with larger values of x and y.
    % In this case flush the whole population an generate an entire new one.
    
    if(strcmp(genFunc2(func, funcProp, eliteIndividual(:,:), individuals(size(individuals,1))),'y') || strcmp(genFunc2(func, funcProp, eliteIndividual(:,:), individuals(size(individuals,1))),'x'))
        individuals = generatePopulation(popSize, funcIn, inputs, func, layers, nodes);
        
    end
    
    
end
end
