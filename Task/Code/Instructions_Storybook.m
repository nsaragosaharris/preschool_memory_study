%Go to Instructions folder for all of the necessary images and audio files.
cd ../TaskInstructions/StorybookInstructions
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
        title_stimuli = imresize(title_stimuli, 0.4); %make it half the size.
        [s1,s2,s3] = size(title_stimuli);
        % Check if the image is too big to fit on the screen.
        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, title_stimuli);
        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        %HideCursor(); % Uncomment this if using a touch screen.
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);
        [mouseX, mouseY, buttons] = GetMouse(window); %record the x and y position of the mouse.
   
        %If they click on the screen, it starts the instructions.
        if sum(buttons) > 0
        respToBeMade = false;
        
        end
end


for i = 1:3
   
  % Present each instruction slide.
        instruction_stimuli_name = strcat('slide', int2str(i));
        instruction_stimuli = imread(instruction_stimuli_name,'jpg');
        instruction_stimuli = imresize(instruction_stimuli, 0.35); 
        [s1,s2,s3] = size(instruction_stimuli);

       
        if s1 > screenYpixels || s2 > screenYpixels
        disp('Error: Image is too big to fit on the screen');
         sca;
            return;
        end
       
        imageTexture = Screen('MakeTexture', window, instruction_stimuli);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
       
         instruction_audio_filename = strcat('learning_sentence',int2str(i),'.mp3');
         [y,Fs] = audioread(instruction_audio_filename);
         sound(y,Fs);

        % Get duration of the audio file.
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

%Practice clicking the button.
button_press_picture = imread('button','jpg');
button_press_picture = imresize(button_press_picture, [600 600]); 
[s1,s2,s3] = size(button_press_picture);

% Instructions about clicking the button.
for i= 1:3
    
imageTexture = Screen('MakeTexture', window, button_press_picture);
Screen('DrawTexture', window, imageTexture, [], [], 0);
Screen('Flip', window);
instruction_audio_filename = strcat('practice_button_press_',int2str(i),'.mp3');
[y,Fs] = audioread(instruction_audio_filename);
sound(y,Fs);
x = audioinfo(instruction_audio_filename); 
audio_length = x.Duration;
WaitSecs(audio_length);

end


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
                    
                    button_audio_filename = ('button_soundeffect.mp3');
                    [y,Fs] = audioread(button_audio_filename);
                    sound(y,Fs);
                    WaitSecs(2);
                    respToBeMade = false; %update response to be made
                  
                    % Show quick blank screen in between each page.
                    blank_stimuli = imread('blank','jpg');
                    [s1,s2,s3] = size(blank_stimuli);
                    imageTexture = Screen('MakeTexture', window, blank_stimuli);
                    Screen('DrawTexture', window, imageTexture, [], [], 0);
                    Screen('Flip', window);
                    WaitSecs(0.5);
                    
              
                
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
         
    % This is the "great job" part.
    greatjob_stimuli = imread('slide18','jpg');
    greatjob_stimuli = imresize(greatjob_stimuli, 0.4); 
    [s1,s2,s3] = size(greatjob_stimuli);
    imageTexture = Screen('MakeTexture', window, greatjob_stimuli);
    Screen('DrawTexture', window, imageTexture, [], [], 0);
    Screen('Flip', window);
    greatjob_audio_filename = strcat('memory_sentence18','.mp3');
    [y,Fs] = audioread(greatjob_audio_filename);
    sound(y,Fs);
    WaitSecs(2);
  
    blank_stimuli = imread('blank','jpg');
    [s1,s2,s3] = size(blank_stimuli);
    imageTexture = Screen('MakeTexture', window, blank_stimuli);
    Screen('DrawTexture', window, imageTexture, [], [], 0);
    Screen('Flip', window);
    WaitSecs(0.5);
    
    for i = 4:5
   
  % Present each instruction slide.
        instruction_stimuli_name = strcat('slide', int2str(i));
        instruction_stimuli = imread(instruction_stimuli_name,'jpg');
        instruction_stimuli = imresize(instruction_stimuli, 0.35); 
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
       
         instruction_audio_filename = strcat('learning_sentence',int2str(i),'.mp3');
         [y,Fs] = audioread(instruction_audio_filename);
         sound(y,Fs);

         x = audioinfo(instruction_audio_filename); 
         audio_length = x.Duration; 
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

WaitSecs(2);
%Return to Code directory to run next script.
cd ../../Code
% Clear the screen.
%sca;
