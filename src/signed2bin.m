function bin = signed2bin (cell_val)

if cell_val < 0
    binary_size = length(dec2bin(cell_val*(-1)));
    inv_multiplier = (2^binary_size) -1;
    bin = dec2bin((cell_val + inv_multiplier), binary_size);
elseif cell_val == 0
    bin = [];
else
    bin = dec2bin(cell_val);    
end

end
