function video = fonte (source)

testeVideo = VideoReader(source);
 %separate the video frames in a struct rgb
f=1;
while hasFrame(testeVideo)
    img = double (readFrame(testeVideo));
    video.R(:,:,f) = img(:,:,1);
    video.G(:,:,f) = img(:,:,2);
    video.B(:,:,f) = img(:,:,3);
    f=f+1;
end


end
