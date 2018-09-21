function [ str ] = genFunc( call, numargs, arg1, arg2, arg3)
%GENFUNC Concats the strings of the function
%%   Concats strings and brackets to a string that can be calculated using the eval();

argString = strcat('(',arg1);
if(numargs >= 2)
    argString = strcat(argString,['' arg2]);
end
if(numargs >= 3)
    argString = strcat(argString,[',' arg3]);
end
argString = strcat(argString,')');

str = strcat(call,argString);

end

