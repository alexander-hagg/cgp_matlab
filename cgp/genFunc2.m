function [ str ] = genFunc2( func, funcProp, individual, src)
%GENFUNC2 Main of the recursive function generation
%   follows the trace from output to input recursivly

%% go into recursion if source is not a input value
if(src > 2)
    komma =',';
    %%
    % create first argument as recursive call
    x = strcat(genFunc2(func, funcProp, individual,individual(src,1)),komma);
    %%
    % create second argument as recursive call
    y = genFunc2(func, funcProp, individual,individual(src,2));
    %%
    % build string when recursion is done executing
    str = genFunc(func(individual(src,3)),...
        funcProp(individual(src,3)), ...
        x, ...
        y);
    %% ELSE: reach end of recursion
    % "else" is for when recursion reaches a input as source.
    % Insert "x" or "y" into the string, so it can be evaluated with different
    % values for x and y.
else
    
    switch(src)
        case 1
            str = 'x';
        case 2
            str = 'y';
    end
end

