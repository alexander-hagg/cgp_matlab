function [ res ] = pow( x, y )
%POW x^y
%   Detailed explanation goes here

    res = x^y;
    if(isinf(res))
        res = x;
    end
    
end

