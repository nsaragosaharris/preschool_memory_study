% This is to practice putting a box around the correct image on the screen.
% Uses a defined location on the screen to draw a rectangle.
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

%Present slide.
        instruction_stimuli_name = strcat('slide', int2str(17));
        instruction_stimuli = imread(instruction_stimuli_name,'jpg');
        instruction_stimuli = imresize(instruction_stimuli, 0.5); 
        [s1,s2,s3] = size(instruction_stimuli);

        % Make the image into a texture.
        imageTexture = Screen('MakeTexture', window, instruction_stimuli);

        % Draw the image to the screen; will draw the texture full size in the center of the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        % Flip to the screen. This command draws all previous commands onto the screen.
        Screen('Flip', window);

        WaitSecs(2);

        % Draws rectangle in bottom right corner of the screen.
        rectLoc = [xCenter+100 yCenter+50 xCenter+400 yCenter+250];
        %Draw image again so that it stays on the screen.
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('FrameRect', window, white, rectLoc, 5) %draw a white rectangle.
        Screen('Flip', window) %flip to the screen.
        % Wait for a keyboard button press (any key) to end.
        WaitSecs(2);

% Clear the screen.
sca;