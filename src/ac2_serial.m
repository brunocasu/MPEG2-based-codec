function A = ac2_serial (M)

A(1, 1:63) = M(1, 1:63);
A(1, 64:126) = M(2, 1:63);
end