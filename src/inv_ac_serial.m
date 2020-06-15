function array_64 = inv_ac_serial(block)

array(1, 1) = 0;
array_64(1, 2:64) = block(1, 1:63);

end
