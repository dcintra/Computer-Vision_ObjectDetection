function labeled_img = generateLabeledImage(gray_img, threshold) 

%----------------- 
% Convert a grayscale image to a binary image
%-----------------
img=gray_img;

bw_img = im2bw(img, threshold);

[L,num] = bwlabel(bw_img,4);

labeled_img = L;

end