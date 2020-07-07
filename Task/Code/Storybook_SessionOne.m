%% Storybook Task %%
% Code written and stimuli created by Natalie Saragosa-Harris, January 2018.
% In this task, participants watch a storybook that shows an animal paired
% with a scene. For each pair, there is corresponding audio that is
% presented at the same time as the picture.
% The pairs (with images and audio) are each presented three times.
% Pairs are presented in a random order.

% There is no test phase in session one.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subject Information.

% Input subject information.
subjectNumber = input('Enter subject number:');
conditionNumber = input('Enter condition number:');
sessionNumber = input('Enter session number:');

%call instructions script.
Instructions_Storybook
%% Read in file with condition details.
% There are four different text files (one for each condition). Load the
% one that corresponds to the condition typed.
% Each text file has three columns.
% First column: pairing names (e.g., "sheep_bowling"). Use this to
% get the combined pictures and audio.
% Second column: animal. Use this to get the animal picture and audio.
% Third column: place. Use this to get the place picture and audio.
cd ../Stimuli
condition_filename = ['condition',int2str(conditionNumber), '.txt'];
fileID_1 = fopen(condition_filename,'r');

% Tell program that the file's format is three columns of strings.
formatSpec_1 = '%s\t%s\t%s\t';
% A is now a 3x10 array that holds the three columns from the file.
A = textscan(fileID_1,formatSpec_1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Screen Information.
% Uncomment this section if you are not calling the instructions first.

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

% Directory should be the folder that has all of the images and
% audio files together.
cd All_Pictures_And_Audio

%% Create data file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
storybook_filename = [int2str(subjectNumber),'_Condition',int2str(conditionNumber), '_Session',int2str(sessionNumber),'_SessionOne.txt'];
% Make sure there isn't already a file name for that subject (but would also have to
% be same condition to give error message).
if exist (storybook_filename, 'file')
    subjectNumber = input('File already exists. Enter a different subject number:');
end

fileID = fopen(storybook_filename, 'w'); % 'w' for write, 'r' for read.

%specify file format. Data will be saved in a table with five columns.
% Column 1: Trial number.
% Column 2: Name of animal place pair.
% Column 3: Trial start (trial is for button press).
% Column 4: Trial end.
% Column 5: Time between button appearing on screen and participant clicking the button.
% 
formatSpec = '%d\t%s\t%d\t%d\t%d\n'; %'s' means string, 'd' means decimal
% (number; defaults to no decimal point),'f' means fixed point (can specify how many points after decimal point).

% Also create a .mat file to save each iteration of the loop.
matlab_filename = [int2str(subjectNumber),'_Condition',int2str(conditionNumber), '_SessionOne'];

%Create an empty array. This will have the five columns to save and a row
%for every trial (three presentations for each of the eight pairs).
array_to_save = cell.empty(8,0);
%Keep track of which row you are in without a loop.
current_row = 1; %increase this each time in inner loop.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus Presentation.

% Go through the files and present the pictures with the audio files.

% Create vector with integers 1 to 8 to shuffle.
rng('shuffle');
shuffled_vector = 1:8;

% This is the outer loop. It ensures that participants see each stimulus
% pair three times in a randomized order.
% Each time the outer loop runs, the vector is shuffled. 
% The inner loop iterates through the shuffled vector, 
% extracts an integer (variable 'index_to_use'), then puts that integer into the index of the vector 
% of pairings (e.g. if 4 is chosen, then go to v(4)).
% Then, it uses the string stored in that index to get the audio file and the image file.
%for(x = 1:3)

%Create new random order for each iteration of the outer loop.
shuffled_vector = shuffled_vector(randperm(length(shuffled_vector))); 
    for(i = 1:length(shuffled_vector))
    
           index_to_use = shuffled_vector(i);
          % Save current trial to array (should be same as row).
          array_to_save{current_row, 1} = current_row;
          % Save pair to array.
          array_to_save{current_row, 2} = A{1}{index_to_use};
        
  % Present animal.
        animal_stimuli = imread(A{2}{index_to_use},'jpg');
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

        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        HideCursor();
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        
        %WaitSecs(2);
        %sca;

        % Important: It makes the most sense for the audio files to be saved in the
        % same directory as the image files.
        
         animal_audio = A{2}{index_to_use};
         animal_audio_filename = strcat(animal_audio,'.mp3');
         [y,Fs] = audioread(animal_audio_filename);
         sound(y,Fs);


        % Get duration of the audio file. This should also work for .mp3
        % files.
         x = audioinfo(animal_audio_filename); % This is a struct object with information about the audio file.
         audio_length = x.Duration; % Get the "duration" variable from the struct object.
        % Show screen for duration of the audio file. Pause several extra
        % seconds in between each stimulus presentation.
         %WaitSecs(audio_length);
         WaitSecs(5);
        
        % Show quick blank screen in between each page.
        blank_stimuli = imread('blank','jpg');
        [s1,s2,s3] = size(blank_stimuli);
        imageTexture = Screen('MakeTexture', window, blank_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        WaitSecs(0.5);
         
    % Present place.
        place_stimuli = imread(A{3}{index_to_use},'jpg');
        place_stimuli = imresize(place_stimuli, [600 600]);
        [s1,s2,s3] = size(place_stimuli);
        
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end

        imageTexture = Screen('MakeTexture', window, place_stimuli);

        Screen('DrawTexture', window, imageTexture, [], [], 0);
      
        Screen('Flip', window);

        place_audio = A{1}{index_to_use};
        place_audio_filename = strcat(place_audio,'.mp3');
        [y,Fs] = audioread(place_audio_filename);
        sound(y,Fs);
        
        x = audioinfo(place_audio_filename); 
        audio_length = x.Duration;
        %WaitSecs(audio_length);
        WaitSecs(5);
        
       % Show quick blank screen in between each page.
        blank_stimuli = imread('blank','jpg');
        [s1,s2,s3] = size(blank_stimuli);
        imageTexture = Screen('MakeTexture', window, blank_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        WaitSecs(0.5);
         
   % Present animal in place.
        both_stimuli = imread(A{1}{index_to_use},'jpg');
        both_stimuli = imresize(both_stimuli, [600 600]);
        [s1,s2,s3] = size(both_stimuli);
        
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end

        imageTexture = Screen('MakeTexture', window, both_stimuli);

        Screen('DrawTexture', window, imageTexture, [], [], 0);
      
        Screen('Flip', window);

        
        both_audio = A{1}{index_to_use};
        both_audio_filename = strcat('IN_',both_audio,'.mp3');
        [y,Fs] = audioread(both_audio_filename);
        sound(y,Fs);

        x = audioinfo(both_audio_filename); 
        audio_length = x.Duration; 
        %WaitSecs(audio_length);
        WaitSecs(5);
        
        % Show quick blank screen in between each page.
        blank_stimuli = imread('blank','jpg');
        [s1,s2,s3] = size(blank_stimuli);
        imageTexture = Screen('MakeTexture', window, blank_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        WaitSecs(0.5);
        
      %Put button here. Participant must press button to see next
      %animal/place pair.
        button_press_picture = imread('button','jpg');
        button_press_picture = imresize(button_press_picture, [600 600]); 
        [s1,s2,s3] = size(button_press_picture);
        % Check if the image is too big to fit on the screen.
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end
%%%%%%%%%%%
% Because the button image is 600 by 600, the dimensions are x is > xCenter
% - 300 & < xCenter+300 && y is > yCenter-300 & < yCenter+300. Changed to
% 280 because it is a circle within a square.

    %Start trial timer (only timing button response time).
    rt = nan; %initialize rt
    tStart = GetSecs; %get trial start time.
    tEnd = nan; %initialize end time.
    respToBeMade = true;
    while respToBeMade == true %if a valid response has not been made
    % Draw the image.
                imageTexture = Screen('MakeTexture', window, button_press_picture);
                Screen('DrawTexture', window, imageTexture, [], [], 0);
                Screen('Flip', window);
                respToBeMade = true;
    
        [mouseX, mouseY, buttons] = GetMouse(window); %record the x and y position of the mouse.
            if sum(buttons) > 0
            %If the user clicks the screen, compare location of mouse click
            %to the coordinates of the picture.
                if(mouseX > xCenter-280 && mouseX < xCenter+280 && mouseY > yCenter-280 && mouseY < yCenter+280)
                    rt = GetSecs - tStart; %get reaction time.
                    button_audio_filename = ('button_soundeffect.mp3');
                    [y,Fs] = audioread(button_audio_filename);
                    sound(y,Fs);
%                     Screen('FillRect', window,black);
%                     DrawFormattedText(window,'You clicked the button.','center','center',white);
%                     Screen('Flip',window);
                    WaitSecs(2);
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
            end   
    end
    
    array_to_save{current_row, 3} = tStart;
    array_to_save{current_row, 4} = tEnd;
    array_to_save{current_row, 5} = rt;
    
% Save data.
     fileID = fopen(storybook_filename, 'a');  %'a' for appending data to existing file.
     fprintf(fileID,formatSpec,array_to_save{current_row, :}); %Saves new information in a row each time (each row is a trial).
     %fprintf writes a space-delimited file.
     %Close the file.
     fclose(fileID);
    %Move to next row of the array for next iteration of the loop.
     current_row = current_row+1;
     
     save(matlab_filename);
   end

%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End Screen.
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
% Save.
save(matlab_filename);