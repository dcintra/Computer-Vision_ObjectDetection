function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)


fh1=figure();
imshow(orig_img);
hold on;

%Retrieve edge-detector image
edge_img = edge(orig_img,'canny', 0.07);

houghacc = hough_img;
maxValue = max(houghacc(:));

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
            
            theta = thetasIndex(1,j);
            
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
linesegment = [];
linesegmentStart = 0;

    for a=1:size(rhoThetaValues,1)
        for b=1:columns
            if(rhoThetaValues(a,1)==0)
                y = rhoThetaValues(a,2);
                
                for loop=1:size(orig_img,1)
                    A=loop;
                    B=y;
                    if(edge_img(A,B) ==1)
                                new_row = [B A];
                                linesegment = [linesegment; new_row];  
                                linesegmentSize = size(linesegment,1);
                                if(linesegmentSize==1)
                                    startX= linesegment(1,1);
                                    startY= linesegment(1,2);

                                elseif(linesegmentSize>1) % Check if not first point
                                    %Check Distance of Points
                                    xDistance = linesegment(linesegmentSize,1)-linesegment(linesegmentSize-1,1);
                                    yDistance = linesegment(linesegmentSize,2)-linesegment(linesegmentSize-1,2);
                                    distance = sqrt(xDistance^2+yDistance^2);

                                        if(distance >85)
                                            endX= linesegment(linesegmentSize-1,1);
                                            endY= linesegment(linesegmentSize-1,2);
                                            hold on;  
                                      %Plot lines
                                            plot([startY endY],[startX endX] ,'LineWidth',2, 'Color', [0, 1, 0]);
                                            plot(startY, startX, 'Marker', '*', 'MarkerEdgeColor', 'r')
                                            plot(endY, endX, 'Marker', '*', 'MarkerEdgeColor', 'y')
                                            linesegment=[];
                                            startX=[];
                                            startY=[];
                                            endY =[];
                                            endY =[];
                                        end %end distance and plot statement
                                end
                    end
                end
                
                
            else
                    y = (-cos(rhoThetaValues(a,1))/sin(rhoThetaValues(a,1)))*b+(rhoThetaValues(a,2)/sin(rhoThetaValues(a,1)));
                  if(y>size(orig_img,2) || b>size(orig_img,1) || y<0)

                  else
                     by = [b y];
                     linesCoord = [linesCoord; by];
                  end
            end
        end
    
            %Check if point is in edge image 
            for i=1:size(linesCoord,1)

                Coord = linesCoord(i,:);
                X = round(Coord(1,1));
                Y = Coord(1,2);
                Y = ceil(Y);
                %Keep relevant Points
                    if(X>0 && Y>0 && Y<size(edge_img,2))
                    %Check if point can be found in edge_hough image 
                            if(edge_img(X,Y) ==1)
                                new_row = [X Y];
                                linesegment = [linesegment; new_row];  
                                linesegmentSize = size(linesegment,1);
                                if(linesegmentSize==1)
                                    startX= linesegment(1,1);
                                    startY= linesegment(1,2);

                                elseif(linesegmentSize>1) % Check if not first point
                                %Check Distance of Points
                                    xDistance = linesegment(linesegmentSize,1)-linesegment(linesegmentSize-1,1);
                                    yDistance = linesegment(linesegmentSize,2)-linesegment(linesegmentSize-1,2);
                                    distance = sqrt(xDistance^2+yDistance^2);

                                        if(distance >12)
                                            endX= linesegment(linesegmentSize-1,1);
                                            endY= linesegment(linesegmentSize-1,2);
                                            hold on;  
                                      %Plot lines
                                            plot([startY endY],[startX endX] ,'LineWidth',2, 'Color', [0, 1, 0]);
                                            plot(startY, startX, 'Marker', '*', 'MarkerEdgeColor', 'r')
                                            plot(endY, endX, 'Marker', '*', 'MarkerEdgeColor', 'y')
                                            linesegment=[];
                                            startX=[];
                                            startY=[];
                                            endY =[];
                                            endY =[];
                                        end %end distance and plot statement

                                end %end check if first point
                            end

                    end %end check if point is in image 

             end %end checkif point is in edge_hough 
    end
        
            
  cropped_line_img = saveAnnotatedImg(fh1);  
        
    
end


 
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
end
