function source = destino (compressed_video_rgb, numfiles)

source=1;

%Para criar o video
video = VideoWriter('compressed_video.avi','Uncompressed AVI');
video.FrameRate = 12;
open(video)

%Processa as Imagens e Cria o Video
for i = 1:numfiles
    image(:,:,1) = compressed_video_rgb.R(:,:,i);
    image(:,:,2) = compressed_video_rgb.G(:,:,i);
    image(:,:,3) = compressed_video_rgb.B(:,:,i);
    image = uint8(image);
    writeVideo(video,image)
end
close(video)

end
