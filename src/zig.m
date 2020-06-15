function frame_serial = zig(frame_ypbpr)

horizontal_size = size(frame_ypbpr.Y_quantized,2);
vertical_size = size(frame_ypbpr.Y_quantized,1);
f_size = horizontal_size*vertical_size;

fun = @(block_struct) zig_block(block_struct.data);

Y_concat = blockproc(frame_ypbpr.Y_quantized, [8 8], fun);
frame_serial.Y = reshape(Y_concat',1,[]);

Pb_concat = blockproc(frame_ypbpr.Pb_quantized, [8 8], fun);
frame_serial.Pb = reshape(Pb_concat',1,[]);

Pr_concat = blockproc(frame_ypbpr.Pr_quantized, [8 8], fun);
frame_serial.Pr = reshape(Pr_concat',1,[]);

frame_serial.YPbPr = zeros(1, 3*f_size);
for i =1:64
    frame_serial.YPbPr(1, i:192:3*f_size) = frame_serial.Y(1, i:64:end);
    frame_serial.YPbPr(1, i+64:192:3*f_size) = frame_serial.Pb(1, i:64:end);
    frame_serial.YPbPr(1, i+128:192:3*f_size) = frame_serial.Pr(1, i:64:end);
end

end
