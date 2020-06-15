function compressed_frame_rgb = inv_dct(frame_ypbpr, scale_factor)

horizontal_size = size(frame_ypbpr.Y_quantized,2);
vertical_size = size(frame_ypbpr.Y_quantized,1);
 
%matriz de quantização para canais de luminância.
Q_Lum=[ 16   11  10  16  24  40  51  61;
        12   12  14  19  26  58  60  55;
        14   13  16  24  40  57  69  56;
        14   17  22  29  51  87  80  62;
        18   22  37  56  68  109 103 77;
        24   35  55  64  81  104 113 92;
        49   64  78  87  103 121 120 101;
        72   92  95  98  112 100 103 99];

%matriz de quantização para canais de luminância.
Q_Cro=[ 17   18  24  47  99  99  99  99;
        18   21  26  66  99  99  99  99;
        24   26  56  99  99  99  99  99;
        47   66  99  99  99  99  99  99;
        99   99  99  99  99  99  99  99;
        99   99  99  99  99  99  99  99;
        99   99  99  99  99  99  99  99;
        99   99  99  99  99  99  99  99];

Qa = repmat(Q_Lum,vertical_size/8,horizontal_size/8);
Qb = repmat(Q_Cro,vertical_size/8,horizontal_size/8);

compressed_Y = zeros([vertical_size, horizontal_size]);
compressed_Pb = zeros([vertical_size, horizontal_size]);
compressed_Pr = zeros([vertical_size, horizontal_size]);

inv_Y_quantized = frame_ypbpr.Y_quantized.*(Qa*scale_factor);
inv_Pb_quantized = frame_ypbpr.Pb_quantized.*(Qa*scale_factor);
inv_Pr_quantized = frame_ypbpr.Pr_quantized.*(Qa*scale_factor);

fun = @(block_struct) inv_dct_block(block_struct.data);

compressed_Y = blockproc(inv_Y_quantized, [8 8], fun);
compressed_Pb = blockproc(inv_Pb_quantized, [8 8], fun);
compressed_Pr = blockproc(inv_Pr_quantized, [8 8], fun);

compressed_frame_rgb.R = (compressed_Pr/0.713) + compressed_Y; 
compressed_frame_rgb.B = (compressed_Pb/0.564) + compressed_Y;
compressed_frame_rgb.G = (compressed_Y - 0.299*compressed_frame_rgb.R - 0.114*compressed_frame_rgb.B)/0.587;

end
