function [obj_db, out_img] = compute2DProperties(orig_img, labeled_img)

obj_db=[];

labeled_img = bwlabel(labeled_img);


num = max(unique(labeled_img));
fh1 = figure();
imshow(orig_img);
hold on;

 for a = 1:num
    %find specific object
     objectlabel = a;
     regionOfObject = (labeled_img==a);
     areaOfObject = sum(regionOfObject(:));
     [rows,columns] = size(regionOfObject);
     j = ones(rows,1)*[1:columns];
     i = [1:rows]'*ones(1,columns);

    %----------------------------
    %Calculate Centroid
    %----------------------------

    centerPositionX = sum(sum(double(regionOfObject).*j))/areaOfObject;
    centerPositionY = sum(sum(double(regionOfObject).*i))/areaOfObject;

    %----------------------------
    %Second Moment: Orientation
    %----------------------------
    jPrime = j - centerPositionX;
    iPrime = i - centerPositionY;

    %Find a'
    aPrime = sum(sum(double(regionOfObject).*jPrime.*jPrime));

    %Find b'
    bPrime = 2*(sum(sum(double(regionOfObject).*jPrime.*iPrime)));

    %Find c'
    cPrime = sum(sum(double(regionOfObject).*iPrime.*iPrime));

    %Find Theta
    aPrimeMinuscPrime = (aPrime-cPrime);

    denominator = sqrt((bPrime^2)+(aPrimeMinuscPrime^2));

    if (bPrime==0) && (aPrimeMinuscPrime==0)
        orientation = 0;
        roundness = 1;
    else

        %Find Orientation: Theta
        sinTwotheta = bPrime/denominator;
        cosTwotheta = aPrimeMinuscPrime/denominator;
        twoTheta = atan2d(sinTwotheta,cosTwotheta);
        
        %Orientation in Degrees
        orientation = -twoTheta/2;

        %Find Roundness
         Emin = (cPrime+aPrime)/2 - (aPrime-cPrime)*cosTwotheta/2 - bPrime*sinTwotheta/2;
         Emax = (cPrime+aPrime)/2 - (aPrime-cPrime)*(-cosTwotheta)/2 - bPrime*(-sinTwotheta)/2; 
         roundness = Emin/Emax;

    end
 
    %Check for holes in object
    IM2 = imcomplement(regionOfObject);
    processed_img = bwmorph(IM2, 'erode',1);
    processed_img = bwmorph(processed_img, 'dilate');
    [L,num] = bwlabel(processed_img,8);
    
    numberOfHoles = num-1;

    %Aspect Ratio
    J = [aPrime bPrime/2; bPrime/2 cPrime];
    lambda = eig(J);
    
    x = 2 * sqrt(lambda(2) / areaOfObject);
    y = 2 * sqrt(lambda(1) / areaOfObject);
    
    aspectRatio = y/x;
    
    obj_db(a,:) =  [objectlabel centerPositionY centerPositionX Emin orientation roundness aspectRatio numberOfHoles];
     
    
    %----------------------------------
    %Plot Centroids & Orientation Lines
    %----------------------------------
    
    %Plot Centroid
    hold on; line(centerPositionX, centerPositionY, 'Marker', '*', 'MarkerEdgeColor', 'r')
    

    %Plot Orientation Axis
    startX = centerPositionX;
    startY = centerPositionY;
    
    hypotenuse = 20/(cosd(orientation));
    
    endX = centerPositionX+20;
    endY = centerPositionY+(sind(orientation)*hypotenuse);
    
    hold on; plot([startX endX], [startY endY]);
  
    
 end
 
 %Plot Centroid and Orientation
 
 
 out_img = saveAnnotatedImg(fh1);
 
 
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

 
 
