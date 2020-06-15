function array = zig_block (Z)

% The first step is to transform the 8x8 block in an array of scrambled data.
% The values are ordered by the example of matrix M (this matrix is not used)
%
% M = [1,  2,  6,  7,  15, 16, 28, 29;
%      3,  5,  8,  14, 17, 27, 30, 43;
%      4,  9,  13, 18, 26, 31, 42, 44;
%      10, 12, 19, 25, 32, 41, 45, 54;
%      11, 20, 24, 33, 40, 46, 53, 55;
%      21, 23, 34, 39, 47, 52, 56, 61;
%      22, 35, 38, 48, 51, 57, 60, 62;
%      36, 37, 49, 50, 58, 59, 63, 64;];
%
% The input matrix Z is serialized by each line, turning in the matrix R = [1 ,2 ,6 ,7 ,15,16,28,29,3 ,5 ,8 ,14,17 ...] (values from the example).
% By this, the index values of R are are distributed in this sequence  A = [1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10,11,12,13 ...]

% The second step is organize the values in R sequentialy
% When you do that the matrix A is turned in the conversion_matrix
% example: the third value of the conversion_matrix corresponds to index 9 in the matrix R, 
% therefore the value in index 3 of the conversion_matrix gets the ninth value in R

% The final step is create the serialized Z (array) using th values in R with the index of conversion_matrix

conversion_matrix=[1,2,9,17,10,3,4,11,18,25,33,26,19,12,5,6,13,20,27,34,41,49,42,35,28,21,14,7,8,15,22,29,36,43,50,57,58,51,44,37,30,23,16,24,31,38,45,52,59,60,53,46,39,32,40,47,54,61,62,55,48,56,63,64];

R = reshape(Z',1,[]);
array = R(conversion_matrix);

% if the input is the example matrix M, array would be = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ...]

end
