%% Report to Cartesian Genetic Programming (CGP)
% Implementation an report by Daniel Brilz.

%% Task: Symbolic Regression
% The task for this report is to solve three symbolic regressions with cartesian genetic programming.
% These are:
%
% # x*y
% # x+y^2
% # sin(x)

%% Parameters
% This report will run the CGP 10 times for each attempt to solve a
% symbolic regression. Each run will record the fitness (rmse) for the best
% individual of each generation for each attempt. These fitness values will be averaged.
% Also it will report back the function as the solution if found any.
% I will display each solution function that are found and produce a
% mesh plot for one of the solutions each symbolic regression and its target function. Additionally
% i will provide a heatmap for the genotype for one of the individuals for
% each symbolic regression problem.
% 
% Functions used in the CGP to approximate the target functions are:
% 
% * add
% * sub
% * mult
% * div
% * pow
clear;
turns = 10;
xmax = 50;
ymax = 50;

%% Target function: x*y
%
targetFunc = 'x*y';
tic;
fit_t1 = zeros(turns,1000);
for i = 1:turns
    clear elite_t1;
    clear fithelper;
    [function_t1(i,1), fithelper] = CGP_main(targetFunc);
    fit_t1(i,1:size(fithelper,2)) = fithelper;
    maxlength_t1(i) = size(fithelper,2);
end
%%%
%
%
disp(function_t1);
figure(1);
semilogy(mean(fit_t1));hold on;
semilogy(max(fit_t1));hold on;
semilogy(min(fit_t1));
title('Fitness');
xlabel('Generations');ylabel('Fitness (error)');
legend('mean fitness','max fitness','min fitness');
xlim([0 max(maxlength_t1)]);
hold off;
for x_1 = 1:xmax
   for y_1 = 1:ymax
       x = x_1 - (xmax/2);
       y = y_1 - (xmax/2);
       z_pred(x_1,y_1) = eval(cell2mat(function_t1(10,1)));
       z_real(x_1,y_1) = eval(targetFunc);
   end
end
figure(2);
mesh(z_pred);
title(['Solution function: ' num2str(cell2mat(function_t1(10,1)))]);
figure(3);
mesh(z_real);
title(['Target function: ' targetFunc]);
toc
%%% Solutions found to approximate (x*y):
% 


%% Solution analysis: x*y 
%
% The target function x*y is a quite simple function to approximate for the
% CGP. It takes quite less time and so in most cases only a few generations (less
% than 150) to
% find a function that solves the symbolic regression for x*y as seen in the fitness graph. Since
% 'mult(x,y)' is in the pool of operators it is mostly part of the
% solution. Also with swaped arguments resulting in 'mult(y,x). 
% Sometimes CGP bloats the multiplication with some terms that
% reduce themselfs e.g. 'sub(x,x)' or add something that is multiplied by
% something that solves to zero. The error is quite small at the
% beginning already and converges to zero with increased generations. Sometimes
% there are high peaks at the error values, which happens due to how the
% error is calculated. In every generations there are new random pairs of x,y
% variables created which are taken by the CGP to evaluate the generated functions.
% Since the values can differ, the error might be greater or less in
% proportion. Another reason is that elitism carries over the best function
% of the last generation, but eventually this individual only performed good
% on the random x,y pairs of the last generation, but does worse on the
% next random pairs. So fitness (error) may rise even though elitism
% carries the supposedly well performing individual. To even this out a bit
% CGP performs a double evaluation each generation and adds up the
% calculated error. 
%
% The meshes of the solution and the target function are identical and behave as expected. 
% So we can say the problem is solved with no error.

%% Target function: x+y^2
%
targetFunc = 'x+y^2';
fit_t2 = zeros(turns,1000);
tic;
clear fithelper;
for i = 1:turns
    clear elite_t2;
    clear fithelper;
    [function_t2(i,1), fithelper] = CGP_main(targetFunc);
    fit_t2(i,1:size(fithelper,2)) = fithelper;
    maxlength_t2(i) = size(fithelper,2);
end
%%%
%
disp(function_t2);
figure(5);
semilogy(mean(fit_t2));hold on;
semilogy(max(fit_t2));hold on;
semilogy(min(fit_t2));
title(['Fitness for symbolic regression:' num2str(targetFunc)]);
xlabel('Generations');ylabel('Fitness (error)');
legend('mean fitness','max fitness','min fitness');
xlim([0 max(maxlength_t2)]);
hold off;
for x_1 = 1:xmax
   for y_1 = 1:ymax
       x = x_1 - (xmax/2);
       y = y_1 - (xmax/2);
       z_pred(x_1,y_1) = eval(cell2mat(function_t2(10,1)));
       z_real(x_1,y_1) = eval(targetFunc);
   end
end
figure(6);
mesh(z_pred);
title(['Solution function: ' num2str(cell2mat(function_t2(10,1)))]);
figure(7);
mesh(z_real);
title(['Target function: ' targetFunc]);
toc

%%% Solutions found to approximate (x+y^2):
%

%% Solution analysis: x+y^2 
%
% The target function x+y^2 is a more complex function to approximate for the
% CGP. In avergage it takes more attemps (generations) to find a good approximation 
% (mostly around 300  to 800) depending on how much 'luck' you get with the
% random initialization and mutations or crossover as seen in the fitness graph. Even with 'power of'
% operator is part of the operator set it is not used in here. GCP
% recognizes the target functions connection of an addition comined with a
% 'self multiplication' of the secound variable.
% So the most common solution is 'add(x, mult(y,y))', which is also appearing 
% with swaped arguments. In most cases an exact solution that matches the
% target function is found.
% Sometimes CGP bloats the core solution with some terms that
% reduce themselfs e.g. 'sub(x,x)' or add something that is multiplied by
% something that solves to zero. The error is quite small at the
% beginning already, but higher compared to the first target function (x*y).
% In the majority of the cases it converges to zero with increased generations within 1000 generations. 
% The error peaks are getting larger compared to the symbolic regression problem. 
% This related to the x+y^2 function producing greater values at all and so
% eventually the error maybe be larger.
%
% The meshes of the solution and the target function are identical and behave as expected.
% So we can say the problem is solved with no error.

%% Target function: sin(x)
%
tic;
clear fithelper;
targetFunc = 'sin(x)';
fit_t3 = zeros(turns,1000);
for i = 1:turns
    clear fithelper;
    [function_t3(i,1), fithelper] = CGP_main(targetFunc);
    fit_t3(i,1:size(fithelper,2)) = fithelper;
    maxlength_t3(i) = size(fithelper,2);
end
%%%
%
%
disp(function_t3);
figure(9);
semilogy(mean(fit_t3));hold on;
semilogy(max(fit_t3));hold on;
semilogy(min(fit_t3));
title('Fitness');
xlabel('Generations');ylabel('Fitness (error)');
legend('mean fitness','max fitness','min fitness');
xlim([0 max(maxlength_t3)]);
hold off;
for x_1 = 1:xmax
   for y_1 = 1:ymax
       x = x_1 - (xmax/2);
       y = y_1 - (xmax/2);
       z_pred(x_1,y_1) = eval(cell2mat(function_t3(10,1)));
       z_real(x_1,y_1) = eval(targetFunc);
   end
end
figure(10);
mesh(z_pred);
title(['Solution function: ' num2str(cell2mat(function_t3(10,1)))]);
figure(11);
mesh(z_real);
title(['Target function: ' targetFunc]);
toc
%%% Solutions found to approximate (sin(x)):
% 

%% Solution analysis: sin(x) 
%
% The target function sin(x) is a very complex function to approximate for the
% CGP. It takes the most attemps (generations) to find a relativly good approximation. 
% Mostly it wont find any good solutions in all of the 1000 generations.
% This is probably not because the CGP
% is poorly designed or performs bad (since it solves the other symbolic
% regression problems), but its toolset of operators is missing some
% important parts like scalars. 
% The error peaks can be even higher than the ones of previews problems
% which is due to lack of improvement from generation to generation which then is caused by
% the non complete operator set. But the peaks are also cause by how elitism works in
% CGP. As explained earlier a individual can perform well on a random pair
% of variables but perform very poor on the next set. And this is what happens alot here. And also this has the most
% impact in this case.
% CGP recognizes that the target functions valus only vary from 1 to -1 as
% visualized in the mesh of the target function. 
% With the given set of tools CGP tries to form a function that lays
% between 1 and -1 and so causes the least errors. That is acutally not how
% sinus function works, but its the closes the CGP can get with its
% operators. As seen in the mesh of the solution function the values of the
% solution laying around the zero mark. This is best compromise in case of error values for all
% input arguments. The maximum error this solution can get is 1 (if sin(x)
% = 1 or -1 and the solution is zero).
% Additionally the CGP sometimes bloats the core solution with some terms that
% reduce themselfs e.g. 'sub(x,x)' or add something that is multiplied by
% something that solves to zero. The error is mostly quite large at the
% beginning already, but progresses to a average error level of 1.
%
% The meshes of the solution and the target function are obviously not identical. 
% The CGP behaved as expected and returned the best approximation (with the average least errors over all inputs) it can get.
% Concludingly we can say the problem is not solved with no error, 
% but we can that we have function of which the error is at max 1 even though it is not a very exiting one.
