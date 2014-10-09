function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)

fh1=figure()
imshow(orig_img);
hold on;

houghacc = hough_img;
maxValue = max(houghacc(:))

thresholdValue = hough_threshold*maxValue;

abovethreshold = houghacc >= thresholdValue;

numberofPoints = sum(abovethreshold(:));

rhoThetaValues = zeros(numberofPoints,2);

[rows, columns] = size(abovethreshold);

thetasIndex = (-(180*pi/180):(pi/180):(180*pi/180));

index = 1

for i=1:rows
    for j=1:columns
        if (abovethreshold(i,j) >0)
            
            theta = thetasIndex(1,j)
            
            rhoValue = i-801;
                    
            thetaRhoPair = [theta, rhoValue];
            
            rhoThetaValues(index,:) = thetaRhoPair;
            if(index < numberofPoints)
                index = index +1;
            end
        end
        
    end
end

linesCoord = [];

rhoThetaValues;

for a=1:size(rhoThetaValues,1)
    for b=1:columns
        
        y = (-cos(rhoThetaValues(a,1))/sin(rhoThetaValues(a,1)))*b+(rhoThetaValues(a,2)/sin(rhoThetaValues(a,1)));
        
        linesCoord(b,:) = [[b y]];
    end
    for i=2:size(linesCoord,1)
        hold on; line(linesCoord(i-1:i, 2), linesCoord(i-1:i, 1),'LineWidth',2, 'Color', [0, 1, 0]);
    end
end
    
line_detected_img = saveAnnotatedImg(fh1);



 
function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;






    
    



