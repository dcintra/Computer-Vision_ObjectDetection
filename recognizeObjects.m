function output_img = recognizeObjects(orig_img, labeled_img, obj_db)


countOfMatches = 0;

[orig_obj_db, out_img] = compute2DProperties(orig_img, labeled_img); 

fh1 = figure();
imshow(orig_img)
hold on;

for i=1:size(orig_obj_db,1)
    for j=1:size(obj_db,1)
        
        label = orig_obj_db(i,1);
        labeldb = obj_db(j,1);
        
        %Check Roundness
        round_Img = orig_obj_db(i,6);
        round_db = obj_db(j,6);
        roundRatio = round_db/round_Img;
        
        
        %Check Aspect Ratio
        aspectRatio_Img = orig_obj_db(i,7);
        aspectRatio_db = obj_db(j,7);
        aspectRatio = aspectRatio_db/aspectRatio_Img;
        
        %Number of Holes
        numOfHoles_Img = orig_obj_db(i,8);
        numOfHoles_db = obj_db(j,8);
        
  
        if(numOfHoles_Img==numOfHoles_db && (0.9<aspectRatio && aspectRatio <1.1) && (0.9<roundRatio && roundRatio <1.1))
          
            countOfMatches=countOfMatches+1;
          
          %----------------------------------
          %Plot Centroids & Orientation Lines
          %----------------------------------
          
          
          %Plot Centroid
       
          startX = orig_obj_db(i,3);
          startY = orig_obj_db(i,2);

          hold on; line(startX, startY, 'Marker', '*', 'MarkerEdgeColor', 'r')

          %Plot Orientation Axis
          orientation = orig_obj_db(i,5);
          hypotenuse = 20/(cosd(orientation));

          endX = startX+20;
          endY = startY+(sind(orientation)*hypotenuse);

          hold on; plot([startX endX], [startY endY])
          
          
        end
    end
end
        


output_img = saveAnnotatedImg(fh1);


 
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






    
    

     