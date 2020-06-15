function [M] = dct_block (L)

n=8;
D = [ sqrt(1/n)*ones(1,n) ;sqrt(2/n)*cos((pi/2/n)*((1:n-1)'*(1:2:2*n))) ];
M = (D)*(L)*(D');

end
