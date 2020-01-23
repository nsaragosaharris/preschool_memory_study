%% Memory Task %%
% Code written and stimuli created by Natalie Saragosa-Harris, January 2018.
% This is the memory test for the Storybook task.
% In this task, participants are instructed to think back to the storybook
% that they saw. On each trial, participants see an animal in the middle of
% the screen and four places (one in each corner of the screen).
% One place is the correct answer, two are incorrect old place pictures, and one is
% an incorrect, completely new place picture.
% They are instructed to click the picture of the animal's favorite place.
% Animals and their corresponding place pictures are presented in a random order.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Subject Information.

% Input subject information.
subjectNumber = input('Enter subject number:');
conditionNumber = input('Enter condition number:');

% Call script for instructions.
Instructions_MemoryTask

%% Read in file with condition details.
% There are four different text files (one for each condition). Load the
% one that corresponds to the condition typed.
cd ../Stimuli/MemoryTask

condition_filename = ['condition',int2str(conditionNumber), '_memory.txt'];
fileID_1 = fopen(condition_filename,'r');

% Tell program that the file's format is five columns of strings.
% First column: Animal.
% Second column: Correct place.
% Third column: Incorrect place 1 (old picture).
% Fourth column: Incorrect place 2 (old picture).
% Fifth column: Foil (place that is completely new).
formatSpec_1 = '%s\t%s\t%s\t%s\t%s\t';
% A is now a 8x5 array that holds the five columns from the file.
A = textscan(fileID_1,formatSpec_1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Screen Information.
% 
% % Get the screen numbers.
% Screen('Preference', 'SkipSyncTests', 1)
% screens = Screen('Screens');
% 
% % Draw to the external screen if avaliable.
% screenNumber = max(screens);
% 
% % Define black and white.
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
% grey = white / 2;
% inc = white - grey;
% 
% % Open an on screen window.
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
% 
% % Get the size of the on screen window.
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% 
% % Query the frame duration.
% ifi = Screen('GetFlipInterval', window);
% 
% % Get the center coordinate of the window.
% [xCenter, yCenter] = RectCenter(windowRect);
% 
% Change directory to be in the folder that has all of the images and
% audio files together.
cd ../StorybookPictures/All_Pictures_And_Audio

%% Create data file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
participant_filename = [int2str(subjectNumber),'_Condition',int2str(conditionNumber), '_Memory.txt'];
% Make sure there isn't already a file name for that subject (but would also have to
% be same condition to give error message).
if exist (participant_filename, 'file')
    subjectNumber = input('File already exists. Enter a different subject number:');
end

fileID = fopen(participant_filename, 'w'); % 'w' for write, 'r' for read.

% Specify file format.
% First column: Trial number.
% Second column: Name of animal.
% Third column: 1 if correct, 0 if not.
% Fourth column: Trial start.
% Fifth column: Trial end.
% Sixth column: Time between two options appearing on screen and participant clicking on one of the two pictures.
% Seventh column: Name of place that they chose.
% Eighth column: Type of place that they chose (correct, incorrect1,
% incorrect2, or foil).

formatSpec = '%d\t%s\t%d\t%d\t%d\t%d\t%s\t%s\n';

% Also create a .mat file to save each iteration of the loop.
matlab_filename = [int2str(subjectNumber),'_Condition',int2str(conditionNumber), '_Memory'];


%Create an empty array. This will have the seven columns to save and a row
%for every trial (eight trials).
array_to_save = cell.empty(8,0);
%Keep track of which row you are in without a loop.
current_row = 1; %increase this each time in inner loop.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shuffle a vector from 1 to 8 to randomize presentation of trials.
shuffled_vector = 1:8;
rng('shuffle');
shuffled_vector = shuffled_vector(randperm(length(shuffled_vector))); 

% Define animal coordinates here.
animal_coordinates = [xCenter-150 yCenter-150 xCenter+150 yCenter+150];
%Define all corner coordinates here.
top_right_coordinates= [xCenter+175 yCenter-420 xCenter+625 yCenter-120];
top_left_coordinates = [xCenter-625 yCenter-420 xCenter-175 yCenter-120];
bottom_right_coordinates= [xCenter+175 yCenter+150 xCenter+625 yCenter+450];
bottom_left_coordinates = [xCenter-625 yCenter+150 xCenter-175 yCenter+450];

%Define coordinates of the rectangles to draw around the picture that the
%participant clicks on.
top_right_rectangle_coordinates = [xCenter+165 yCenter-430 xCenter+635 yCenter-110];
top_left_rectangle_coordinates = [xCenter-635 yCenter-430 xCenter-165 yCenter-110];
bottom_right_rectangle_coordinates = [xCenter+165 yCenter+140 xCenter+635 yCenter+460];
bottom_left_rectangle_coordinates = [xCenter-635 yCenter+140 xCenter-165 yCenter+460];
% % Shuffle vector that decides if correct answer is on right or left.
% right_or_left_vector = [1 1 1 1 2 2 2 2];
% right_or_left_vector=right_or_left_vector(randperm(length(right_or_left_vector)));

% Shuffle vector that decides where on the screen each place is presented.
which_corner_vector = [1 2 3 4 1 2 3 4];

% There are four options for how the places are presented on the screen.

% Option 1. Correct: top right, foil: top left, incorrect1: bottom right,
% incorrect2: bottom left.

% Option 2. Correct: top left, incorrect1: top right, incorrect2: bottom right,
% foil: bottom left.

% Option 3. Correct: bottom right, foil: top right, incorrect1: top left,
% incorrect2: bottom left.

% Option 4. incorrect1: top right, incorrect2: top
% left, foil: bottom right, correct: bottom left.

%Because there are eight pairs and four options, do each option twice and
%shuffle the order in which the options are presented.
rng('shuffle');
which_corner_vector=which_corner_vector(randperm(length(which_corner_vector)));

for i = 1:length(shuffled_vector)
    
 index_to_use = shuffled_vector(i);
% Save current trial to array (should be same as row).
 array_to_save{current_row, 1} = current_row;
% Save name of the animal to array.
 array_to_save{current_row, 2} = A{1}{index_to_use};

% Present animal.
        animal_stimuli = imread(A{1}{index_to_use},'jpg');
        animal_stimuli = imresize(animal_stimuli, [300 300]); 
        
        [s1,s2,s3] = size(animal_stimuli);

        % Check if the image is too big to fit on the screen.
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end

        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, animal_stimuli);

        % Draw animal in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
        %Hide the cursor.
        HideCursor();
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        
        % Play audio.
         animal_audio = A{1}{index_to_use};
         animal_audio_filename = strcat(animal_audio,'.mp3');
         [y,Fs] = audioread(animal_audio_filename);
         sound(y,Fs);
        % Show for 5 seconds so that the stimulus presentation is the same
        % for every animal.
         WaitSecs(5);

 % Define the four place pictures to be presented, resize them, and make them textures.
 % The order of animals to be shown is determined by the shuffled_vector
 % variable.
 % Save the string (name of the correct, incorrect, incorrect2, and foil
 % places) to write to array_to_save.
 
        correct_place = imread(A{2}{index_to_use},'jpg');
        correct_place = imresize(correct_place, [300 300]); 
        [s1,s2,s3] = size(correct_place);
        correct_placeTexture = Screen('MakeTexture', window, correct_place);
        correct_place_string = A{2}{index_to_use};
        
        incorrect_place = imread(A{3}{index_to_use},'jpg');
        incorrect_place = imresize(incorrect_place, [300 300]); 
        [s1,s2,s3] = size(incorrect_place);
        incorrect_placeTexture = Screen('MakeTexture', window, incorrect_place);
        incorrect_place_string = A{3}{index_to_use};
        
        incorrect_place_2 = imread(A{4}{index_to_use},'jpg');
        incorrect_place_2 = imresize(incorrect_place_2, [300 300]); 
        [s1,s2,s3] = size(incorrect_place_2);
        incorrect2_placeTexture = Screen('MakeTexture', window, incorrect_place_2);
        incorrect2_place_string = A{4}{index_to_use};
        
        foil_place = imread(A{5}{index_to_use},'jpg');
        foil_place = imresize(foil_place, [300 300]); 
        [s1,s2,s3] = size(foil_place);
        foil_placeTexture = Screen('MakeTexture', window, foil_place);
        foil_place_string = A{5}{index_to_use};
        
        
        % Play audio.
         click_audio = A{1}{index_to_use};
         click_audio_filename = strcat('touch_', click_audio,'.mp3');
         [y,Fs] = audioread(click_audio_filename);
         sound(y,Fs);
         
        % Show for 5 seconds so that the stimulus presentation is the same.
        % WaitSecs(5);
   
    respToBeMade = true; %keep as true if not clicking one of the two pictures (only change the screen if one of the two is pressed).
    rt = nan; %initialize rt
    tStart = GetSecs; %get trial start time.
    tEnd = nan; %initialize end time.
    
    while respToBeMade == true %if a valid response has not been made        
        
% Present four places on the screen, using the shuffled right_or_left_vector to 
 % determine if the correct place is on right top, right bottom,
 % left top, or left bottom corner of the screen.        
        
% If 1, present correct answer in top right corner.
% Option 1: Correct: top right, foil: top left, incorrect: bottom right,
% incorrect2: bottom left.
        if which_corner_vector(i) == 1
            Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
            Screen('DrawTexture', window, correct_placeTexture, [], top_right_coordinates, 0);
            Screen('DrawTexture', window, foil_placeTexture, [], top_left_coordinates, 0);
            Screen('DrawTexture', window, incorrect_placeTexture, [], bottom_right_coordinates, 0);
            Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
            Screen('Flip', window);
            
            
% If 2, present correct answer in top left corner.
% Option 2: Correct: top left, incorrect1: top right, incorrect2: bottom right,
% foil: bottom left.
        elseif which_corner_vector(i)==2
            Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
            Screen('DrawTexture', window, correct_placeTexture, [], top_left_coordinates, 0);
            Screen('DrawTexture', window, foil_placeTexture, [], bottom_left_coordinates, 0);
            Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
            Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_right_coordinates, 0);
            Screen('Flip', window);
% If 3, present correct answer in bottom right corner.            
% Option 3: Correct: bottom right, foil: top right, incorrect1: top left,
% incorrect2: bottom left.
        elseif which_corner_vector(i)==3
            Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
            Screen('DrawTexture', window, correct_placeTexture, [], bottom_right_coordinates, 0);
            Screen('DrawTexture', window, foil_placeTexture, [],top_right_coordinates, 0);
            Screen('DrawTexture', window, incorrect_placeTexture, [], top_left_coordinates, 0);
            Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
            Screen('Flip', window);
% If 4, present correct answer in bottom left corner.
% Option 4: incorrect1: top right, incorrect2: top
% left, foil: bottom right, correct: bottom left.
        else
            Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
            Screen('DrawTexture', window, correct_placeTexture, [], bottom_left_coordinates, 0);
            Screen('DrawTexture', window, foil_placeTexture, [], bottom_right_coordinates, 0);
            Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
            Screen('DrawTexture', window, incorrect2_placeTexture, [], top_left_coordinates, 0);
            Screen('Flip', window);
        end
     
        
%Get response from participant.
            [mouseX, mouseY, buttons] = GetMouse(window); %record the x and y position of the mouse.
            if sum(buttons) > 0
            %If the user clicks the screen, compare location of mouse click
            %to the coordinates of the picture.
            
 % Note: This section is really long because it has to redraw every image to the screen
 % for every possible clicking area. It would be better to define a
 % function that does this and just call that function.

         
 %If they clicked the top right side, go into this section.
                if(mouseX> xCenter+165 && mouseX < xCenter+635 && mouseY > yCenter-430 &&mouseY < yCenter-110)
                    
                    rectLoc = top_right_rectangle_coordinates; %Have to make it bigger than the picture, so it is its own set of coordinates.
                    
                    
                    % If this value is 1, correct answer is on the top right so they are correct.
                    if which_corner_vector(i) == 1
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 1;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = correct_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'correct';
                        %rectLoc = top_right_rectangle_coordinates; %Have to make it bigger than the picture, so it is its own set of coordinates.
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end
                    
                    % If this value is 2, correct answer is on the top left so they are incorrect.
                    if which_corner_vector(i) == 2
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect1';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 3, correct answer is on the bottom right so they are incorrect.
                    if which_corner_vector(i) == 3
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = foil_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'foil';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [],top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 4, correct answer is on the bottom left so they are incorrect.
                    if which_corner_vector(i) == 4
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect1';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], top_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                   
                    
                    
                    rt = GetSecs - tStart; %get reaction time.
                    %Added a wait time before exiting the loop so that the
                    %pictures would stay on the screen with the rectangle
                    %around it.
                    WaitSecs(1);
                    respToBeMade = false; %update response to be made
                    tEnd = GetSecs; % end of trial; record time.
                    
                    % Show quick blank screen in between each page.
                    blank_stimuli = imread('blank','jpg');
                    [s1,s2,s3] = size(blank_stimuli);
                    imageTexture = Screen('MakeTexture', window, blank_stimuli);
                    Screen('DrawTexture', window, imageTexture, [], [], 0);
                    Screen('Flip', window);
                    WaitSecs(0.5);
                    
                end
     
  %If they clicked the top left side, go into this section.
            if(mouseX> xCenter-635 && mouseX < xCenter-165 && mouseY > yCenter-430 &&mouseY < yCenter-110)
                    
                rectLoc = top_left_rectangle_coordinates;
 
                
                    % If this value is 1, correct answer is on the top right so they are incorrect.
                    if which_corner_vector(i) == 1
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = foil_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'foil';
                        %rectLoc = top_right_rectangle_coordinates; %Have to make it bigger than the picture, so it is its own set of coordinates.
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end
                    
                    % If this value is 2, correct answer is on the top left so they are correct.
                    if which_corner_vector(i) == 2
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 1;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = correct_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'correct';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 3, correct answer is on the bottom right so they are incorrect.
                    if which_corner_vector(i) == 3
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect1';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [],top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 4, correct answer is on the bottom left so they are incorrect.
                    if which_corner_vector(i) == 4
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect2_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect2';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], top_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    rt = GetSecs - tStart; %get reaction time.
                    %Added a wait time before exiting the loop so that the
                    %pictures would stay on the screen with the rectangle
                    %around it.
                    WaitSecs(1);
                    respToBeMade = false; %update response to be made
                    tEnd = GetSecs; % end of trial; record time.
                    % Show quick blank screen in between each page.
                    blank_stimuli = imread('blank','jpg');
                    [s1,s2,s3] = size(blank_stimuli);
                    imageTexture = Screen('MakeTexture', window, blank_stimuli);
                    Screen('DrawTexture', window, imageTexture, [], [], 0);
                    Screen('Flip', window);
                    WaitSecs(2);
                    
            end
                
        

     %If they clicked the bottom right side, go into this section.
            if(mouseX> xCenter+165 && mouseX < xCenter+635 && mouseY > yCenter+140 &&mouseY < yCenter+460)
                    
                rectLoc = bottom_right_rectangle_coordinates;
 
                
                    % If this value is 1, correct answer is on the top right so they are incorrect.
                    if which_corner_vector(i) == 1
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect1';
                        %rectLoc = top_right_rectangle_coordinates; %Have to make it bigger than the picture, so it is its own set of coordinates.
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end
                    
                    % If this value is 2, correct answer is on the top left so they are incorrect.
                    if which_corner_vector(i) == 2
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect2_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect2';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 3, correct answer is on the bottom right so they are correct.
                    if which_corner_vector(i) == 3
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 1;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = correct_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'correct';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [],top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 4, correct answer is on the bottom left so they are incorrect.
                    if which_corner_vector(i) == 4
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = foil_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'foil';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], top_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    rt = GetSecs - tStart; %get reaction time.
                    %Added a wait time before exiting the loop so that the
                    %pictures would stay on the screen with the rectangle
                    %around it.
                    WaitSecs(1);
                    respToBeMade = false; %update response to be made
                    tEnd = GetSecs; % end of trial; record time.
                    % Show quick blank screen in between each page.
                    blank_stimuli = imread('blank','jpg');
                    [s1,s2,s3] = size(blank_stimuli);
                    imageTexture = Screen('MakeTexture', window, blank_stimuli);
                    Screen('DrawTexture', window, imageTexture, [], [], 0);
                    Screen('Flip', window);
                    WaitSecs(2);
                    
            end
        
 %If they clicked the bottom left side, go into this section.
            if(mouseX> xCenter-635 && mouseX < xCenter-165 && mouseY > yCenter+140 && mouseY < yCenter+460)
                    
                rectLoc = bottom_left_rectangle_coordinates;
 
                
                    % If this value is 1, correct answer is on the top right so they are incorrect.
                    if which_corner_vector(i) == 1
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect2_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect2';
                        %rectLoc = top_right_rectangle_coordinates; %Have to make it bigger than the picture, so it is its own set of coordinates.
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end
                    
                    % If this value is 2, correct answer is on the top left so they are incorrect.
                    if which_corner_vector(i) == 2
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = foil_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'foil';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 3, correct answer is on the bottom right so they are incorrect.
                    if which_corner_vector(i) == 3
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 0;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = incorrect2_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'incorrect2';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [],top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_left_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    
                    % If this value is 4, correct answer is on the bottom left so they are correct.
                    if which_corner_vector(i) == 4
                        %write a 0 or a 1 in the array.
                        array_to_save{current_row, 3} = 1;
                        %Save the name of the place they clicked.
                        array_to_save{current_row, 7} = correct_place_string;
                        % Write what type of place they chose (correct,
                        % incorrect1, incorrect2, or foil).
                        array_to_save{current_row, 8} = 'correct';
                        %rectLoc = top_right_rectangle_coordinates;
                        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                        Screen('DrawTexture', window, imageTexture, [], animal_coordinates, 0);
                        Screen('DrawTexture', window, correct_placeTexture, [], bottom_left_coordinates, 0);
                        Screen('DrawTexture', window, foil_placeTexture, [], bottom_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect_placeTexture, [], top_right_coordinates, 0);
                        Screen('DrawTexture', window, incorrect2_placeTexture, [], top_left_coordinates, 0);
                        Screen('Flip', window);
                    end 
                    
                    rt = GetSecs - tStart; %get reaction time.
                    %Added a wait time before exiting the loop so that the
                    %pictures would stay on the screen with the rectangle
                    %around it.
                    WaitSecs(1);
                    respToBeMade = false; %update response to be made
                    tEnd = GetSecs; % end of trial; record time.
                    % Show quick blank screen in between each page.
                    blank_stimuli = imread('blank','jpg');
                    [s1,s2,s3] = size(blank_stimuli);
                    imageTexture = Screen('MakeTexture', window, blank_stimuli);
                    Screen('DrawTexture', window, imageTexture, [], [], 0);
                    Screen('Flip', window);
                    WaitSecs(2);
                    
            end
            
            
                
            end   
    end
    
    array_to_save{current_row, 4} = tStart;
    array_to_save{current_row, 5} = tEnd;
    array_to_save{current_row, 6} = rt;
    
% Save data.
fileID = fopen(participant_filename, 'a');  %'a' for appending data to existing file.
fprintf(fileID,formatSpec,array_to_save{current_row, :}); %Saves new information in a row each time (each row is a trial).
%Close the file.
fclose(fileID);

% if {mouse is in correct area}
%  draw rectangle around the picture.

current_row = current_row+1; %use current_row for the array. When writing
%to the text file, do 'a' so it appends.

save(matlab_filename);

end


%Show end screen.
        end_stimuli = imread('endslide','jpg');
        end_stimuli = imresize(end_stimuli, 0.4); 
        [s1,s2,s3] = size(end_stimuli);
        % Check if the image is too big to fit on the screen.
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end
        imageTexture = Screen('MakeTexture', window, end_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        
%This is the "great job" audio.
endslide_audio_filename = strcat('greatjoballdone','.mp3');
[y,Fs] = audioread(endslide_audio_filename);
sound(y,Fs);

respToBeMade = true;
while (respToBeMade == true)
    %Keep image on screen until the experimenter touches the screen.
        imageTexture = Screen('MakeTexture', window, end_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        [mouseX, mouseY, buttons] = GetMouse(window); %record the x and y position of the mouse.
   
        %If they click on the screen, it ends the script.
        if sum(buttons) > 0
        respToBeMade = false;
        sca;
        end
end

% Calculate accuracy.
current_sum = 0;
for i = 1:8
current_sum = current_sum + array_to_save{i,3};
% add all the 1s in the second column of the array, save to a variable.
end
accuracy = current_sum/8;

% Save .mat file.
save(matlab_filename);