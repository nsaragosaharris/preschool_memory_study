# Preschool_Memory_Study
Analysis and task code for Saragosa-Harris+, Cohen+, Shen, Sardar, Alberini, & Hartley (in press). 

Citation for use of any code, data, or task: Saragosa-Harris, N.M.+, Cohen, A. O.+, Shen, X., Sardar, H., Alberini, C.M., & Hartley, C.A. (in press). Associative memory persistence in three- to five-year-olds. *Developmental Science*. psyarxiv.com/4syjm. (+) Equal author contribution.


**Task.**

The storybook task and memory assessment used in the paper are provided here. The task was coded in MATLAB 2017a using Psychtoolbox-3 (Brainard, 1997; Pelli, 1997; Kleiner et al., 2007) and administered on a touch screen computer. It is compatible with a non touch screen computer, but if you are doing on a non touch screen you should remove the “HideCursor()” command so that you can see the position of the mouse.
Note that some of the code will need to be changed depending on the size of your screen. Specifically, the coordinates that define where the pictures go on the screen, and the lines of code that use "imresize" will likely need to change depending on the size of your screen.

The two main scripts used are Storybook_SessionOne.m and MemoryTask.m. Within these scripts, the instructions (Instructions_Storybook.m and Instructions_MemoryTask.m) are called.

There are eight possible “conditions”. This simply refers to different versions of the task (i.e., unique sets of animal-place pairs). In this paper, we only used the first four conditions, but have added another four for anyone using the task who would like more trials or versions of the storybook. Each “condition” has two text files: one that is used in the storybook (learning) phase (Stimuli/conditionX.txt) and one that is used in the memory assessment phase (Stimuli/conditionX_memory.txt).

In each storybook condition file (Stimuli/conditionX.txt), there are three columns. The first column is the animal and place together (e.g., “bear_library”), the second column is the animal (e.g., “bear”), and the third column is the place (e.g., “library”). The MATLAB scripts use these to find the correct images and audio files.

In each memory assessment condition file (Stimuli/conditionX_memory.txt), there are five columns. The first column is the cue animal, the second column is the correct place, the third column is incorrect place 1 (old lure 1), the fourth column is incorrect place 2 (old lure 2), and the fifth column is the novel foil. The MATLAB scripts use these to find the correct images and audio files.

The directory assumes that the Code, Stimuli, and TaskInstructions directories are all in the same outer directory. If you download "Task" and keep the organization the same, this directory structure should work. It assumes that you opened the code from the Code directory where the script is saved.

**Data.**

The memory data for all participants included in the paper will be provided here upon publication.

**Analysis.**

The analysis script used for all results reported in the paper will be provided here upon publication.


If you have any questions about the task, email Natalie Saragosa-Harris at nsaragosaharris@ucla.edu.
