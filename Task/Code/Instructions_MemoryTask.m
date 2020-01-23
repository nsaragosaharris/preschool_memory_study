% Written by Natalie Saragosa-Harris.
% January 2018.
% Go to MemoryInstructions folder for all of the necessary images and audio files.
cd ../TaskInstructions/MemoryInstructions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Screen Information.

% Get the screen numbers.
Screen('Preference', 'SkipSyncTests', 1)
screens = Screen('Screens');

% Draw to the external screen if avaliable.
screenNumber = max(screens);

% Define black and white.
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;

% Open an on screen window.
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window.
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration.
ifi = Screen('GetFlipInterval', window);

% Get the center coordinate of the window.
[xCenter, yCenter] = RectCenter(windowRect);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

respToBeMade = true;
while (respToBeMade == true)
    %First show title slide with no audio.
        title_stimuli = imread('title','jpg');
        title_stimuli = imresize(title_stimuli, 0.5); %make it half the size.
        [s1,s2,s3] = size(title_stimuli);
        % Check if the image is too big to fit on the screen.
        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, title_stimuli);
        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        % Flip to the screen. This command draws all previous commands onto the screen.
        HideCursor();
        Screen('Flip', window);
        [mouseX, mouseY, buttons] = GetMouse(window); %record the x and y position of the mouse.
   
        %If they click on the screen, it starts the instructions.
        if sum(buttons) > 0
        respToBeMade = false;
        
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Slides 8 to 16 are instructions for the memory task.
for i = 8:16
   
  % Present each instruction slide.
        instruction_stimuli_name = strcat('slide', int2str(i));
        instruction_stimuli = imread(instruction_stimuli_name,'jpg');
        instruction_stimuli = imresize(instruction_stimuli, 0.4); 
        [s1,s2,s3] = size(instruction_stimuli);

        % Check if the image is too big to fit on the screen.
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end

        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, instruction_stimuli);

        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        
        %WaitSecs(2);
        %sca;

        % Important: It makes the most sense for the audio files to be saved in the
        % same directory as the image files.
        
         %instruction_audio = A{2}{index_to_use};
         instruction_audio_filename = strcat('memory_sentence',int2str(i),'.mp3');
         [y,Fs] = audioread(instruction_audio_filename);
         sound(y,Fs);

        % Get duration of the audio file. This should also work for .mp3
        % files.
         x = audioinfo(instruction_audio_filename); % This is a struct object with information about the audio file.
         audio_length = x.Duration; % Get the "duration" variable from the struct object.
        % Show screen for duration of the audio file. Pause several extra
        % seconds in between each stimulus presentation.
         WaitSecs(audio_length);
         WaitSecs(1);
        
        % Show quick blank screen in between each page.
        blank_stimuli = imread('blank','jpg');
        [s1,s2,s3] = size(blank_stimuli);
        imageTexture = Screen('MakeTexture', window, blank_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        WaitSecs(0.5);
         
end

%Slide 17 is the practice test, 18 is the "great job!"
        instruction_stimuli_name = strcat('slide', int2str(17));
        instruction_stimuli = imread(instruction_stimuli_name,'jpg');
        instruction_stimuli = imresize(instruction_stimuli, 0.4); 
        [s1,s2,s3] = size(instruction_stimuli);

        % Check if the image is too big to fit on the screen.
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end

        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, instruction_stimuli);

        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        
        instruction_audio_filename = strcat('memory_sentence',int2str(17),'.mp3');
        [y,Fs] = audioread(instruction_audio_filename);
        sound(y,Fs);

        % Get duration of the audio file. This should also work for .mp3
        % files.
         x = audioinfo(instruction_audio_filename); % This is a struct object with information about the audio file.
         audio_length = x.Duration; % Get the "duration" variable from the struct object.
        % Show screen for duration of the audio file. Pause several extra
        % seconds in between each stimulus presentation.
         WaitSecs(audio_length);
         WaitSecs(1);

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
instruction_stimuli_name = strcat('slide', int2str(17));
instruction_stimuli = imread(instruction_stimuli_name,'jpg');
instruction_stimuli = imresize(instruction_stimuli, 0.4); 
        
respToBeMade = true;     
mouseX =[]; %initialize x coordinate.
mouseY = []; %initialize y coordinate.
while respToBeMade == true %if a valid response has not been made.
        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, instruction_stimuli);
        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        %respToBeMade = true;
        [mouseX, mouseY, buttons] = GetMouse(window); %record the x and y position of the mouse.
        
        if sum(buttons) > 0
            %If the user clicks the screen, compare location of mouse click
            %to coordinates of picture.
            if(mouseX > xCenter+130 && mouseX < xCenter+420 && mouseY > yCenter+90 && mouseY < yCenter+310)         
                % Draws rectangle in bottom right corner of the screen.
                rectLoc = [xCenter+130 yCenter+90 xCenter+420 yCenter+310];
                %Draw image again so that it stays on the screen.
                Screen('DrawTexture', window, imageTexture, [], [], 0);
                Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
                Screen('Flip', window) %flip to the screen.
                % Wait for a keyboard button press (any key) to end.
                WaitSecs(2);
                respToBeMade = false; 
            else
                tryagain_stimuli = imread('tryagain','jpg');
                tryagain_stimuli = imresize(tryagain_stimuli, 0.4); 
                [s1,s2,s3] = size(instruction_stimuli);
                imageTexture = Screen('MakeTexture', window, tryagain_stimuli);
                Screen('DrawTexture', window, imageTexture, [], [], 0);
                Screen('Flip', window);
                tryagain_audio_filename = strcat('tryagain','.mp3');
                [y,Fs] = audioread(tryagain_audio_filename);
                sound(y,Fs);
                WaitSecs(2);
            end
        end   
end
for i = 18:19
   
  % Present each instruction slide.
        instruction_stimuli_name = strcat('slide', int2str(i));
        instruction_stimuli = imread(instruction_stimuli_name,'jpg');
        instruction_stimuli = imresize(instruction_stimuli, 0.4); 
        [s1,s2,s3] = size(instruction_stimuli);

        % Check if the image is too big to fit on the screen.
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end

        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, instruction_stimuli);

        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        
        %WaitSecs(2);
        %sca;

        % Important: It makes the most sense for the audio files to be saved in the
        % same directory as the image files.
        
         %instruction_audio = A{2}{index_to_use};
         instruction_audio_filename = strcat('memory_sentence',int2str(i),'.mp3');
         [y,Fs] = audioread(instruction_audio_filename);
         sound(y,Fs);

        % Get duration of the audio file. This should also work for .mp3
        % files.
         x = audioinfo(instruction_audio_filename); % This is a struct object with information about the audio file.
         audio_length = x.Duration; % Get the "duration" variable from the struct object.
        % Show screen for duration of the audio file. Pause several extra
        % seconds in between each stimulus presentation.
         WaitSecs(audio_length);
         WaitSecs(1);
        
        % Show quick blank screen in between each page.
        blank_stimuli = imread('blank','jpg');
        [s1,s2,s3] = size(blank_stimuli);
        imageTexture = Screen('MakeTexture', window, blank_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        WaitSecs(0.5);
         
end

WaitSecs(1);
% Go back to Code directory so that it can run the task.
cd ../../Code
%sca;