function compressed_frame_ypbpr = inv_zig (coded_frame_serial, frame_dim)

f_size = (length(coded_frame_serial))/3;
for v = 1:64
    comp_Y_serial  (1, v:64:f_size) = coded_frame_serial(1, v:192:end);
    comp_Pb_serial (1, v:64:f_size) = coded_frame_serial(1, v+64:192:end);
    comp_Pr_serial (1, v:64:f_size) = coded_frame_serial(1, v+128:192:end);
end


V = frame_dim(1,1);
H = frame_dim(1,2);
bs = 8; %block size 8x8
ba = 64;%block area

Z_Y = reshape(comp_Y_serial, bs*H, []);
Z_Pb = reshape(comp_Pb_serial, bs*H, []);
Z_Pr = reshape(comp_Pr_serial, bs*H, []);
%base = zeros(V,H);

%reassemble the frame with correct size
n=1;
for i=1:8
    for j=1:8
    Y(i:8:V,j:8:H) = (Z_Y((n:ba:bs*H),(1:V/8)))';
    Pb(i:8:V,j:8:H) = (Z_Pb((n:ba:bs*H),(1:V/8)))';
    Pr(i:8:V,j:8:H) = (Z_Pr((n:ba:bs*H),(1:V/8)))';
    n=n+1;
    end
end

fun = @(block_struct) inv_zig_block(block_struct.data);

compressed_frame_ypbpr.Y_quantized = blockproc(Y, [8 8], fun);
compressed_frame_ypbpr.Pb_quantized = blockproc(Pb, [8 8], fun);
compressed_frame_ypbpr.Pr_quantized = blockproc(Pr, [8 8], fun);
end
