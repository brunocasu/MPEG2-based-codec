function frame_ypbpr = dct(frame_rgb, scale_factor)

Y = 0.587*frame_rgb.G + 0.299*frame_rgb.R + 0.114*frame_rgb.B;
Pb = 0.564*(frame_rgb.B - Y);
Pr = 0.713*(frame_rgb.R - Y);

horizontal_size = size(Y,2);
vertical_size = size(Y,1);
  
Y_dct = zeros([vertical_size, horizontal_size]);
Pb_dct = zeros([vertical_size, horizontal_size]);
Pr_dct = zeros([vertical_size, horizontal_size]);
 
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

fun = @(block_struct) dct_block(block_struct.data);

Y_dct = blockproc(Y, [8 8], fun);
Pb_dct = blockproc(Pb, [8 8], fun);
Pr_dct = blockproc(Pr, [8 8], fun);

%quantização das matrizes após a função dct
frame_ypbpr.Y_quantized = round(Y_dct./(Qa*scale_factor));
frame_ypbpr.Pb_quantized = round(Pb_dct./(Qb*scale_factor));
frame_ypbpr.Pr_quantized = round(Pr_dct./(Qb*scale_factor));

end
