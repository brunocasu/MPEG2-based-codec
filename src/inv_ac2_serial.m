function array_64 = inv_ac2_serial(block)

array(1, 1) = 0;
array(2, 1) = 0;
array_64(1, 2:64) = block(1, 1:63);
array_64(2, 2:64) = block(1, 64:126);

end
