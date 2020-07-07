# Preschool_Memory_Study
Analysis and task code for Saragosa-Harris+, Cohen+, Shen, Sardar, Alberini, & Hartley (2020). 

Citation for use of any code, data, or task: Saragosa-Harris, N.M.+, Cohen, A.O.+, Shen, X., Sardar, H., Alberini, C.M., & Hartley, C.A. (2020). Associative memory persistence and specificity in three- to five-year-olds.

(+) Natalie Saragosa-Harris and Alexandra Cohen are joint first authors on this paper.

Tasks.

The storybook task and memory assessment used in the paper are provided here. The task was coded in MATLAB 2017a using Psychtoolbox-3 (Brainard, 1997; Pelli, 1997; Kleiner et al., 2007) and administered on a touch screen computer. It is compatible with a non touch screen computer, but if you are doing on a non touch screen you should remove the “HideCursor()” command so that you can see the position of the mouse.

The two main scripts used are Storybook_SessionOne.m and MemoryTask.m. Within these scripts, the instructions (Instructions_Storybook.m and Instructions_MemoryTask.m) are called.

There are eight possible “conditions”. This simply refers to different versions of the task (i.e., unique sets of animal-place pairs). In this paper, we only used the first four conditions, but have added another four for anyone using the task who would like more trials or versions of the storybook. Each “condition” has two text files: one that is used in the storybook (learning) phase (Stimuli/conditionX.txt) and one that is used in the memory assessment phase (Stimuli/conditionX_memory.txt).

In each storybook condition file (Stimuli/conditionX.txt), there are three columns. The first column is the animal and place together (e.g., “bear_library”), the second column is the animal (e.g., “bear”), and the third column is the place (e.g., “library”). The MATLAB scripts use these to find the correct images and audio files.

In each memory assessment condition file (Stimuli/conditionX_memory.txt), there are five columns. The first column is the cue animal, the second column is the correct place, the third column is incorrect place 1 (old lure 1), the fourth column is incorrect place 2 (old lure 2), and the fifth column is the novel foil. The MATLAB scripts use these to find the correct images and audio files.

The directory assumes that the Code, Stimuli, and TaskInstructions directories are all in the same outer directory. It assumes that you opened the code from the Code directory where the script is saved.

Data.

The memory data for all participants included in the paper are provided here.

StudyID: Unique participant ID number.

Age: Age of participant in years.

Gender: Parent-reported gender of participant.

StorybookVersion: Which “condition” or version of the task (corresponds to condition text file in Stimuli directory). 

DelayCondition: 1 = five minutes, 2 = 24 hours, 3 = one week.

Trial: Trial number (order in which participant saw the trial).

Animal: Cue animal presented on that trial.

TrialAccuracy: 0 = incorrect, 1 = correct.

Begin: Time at start of trial.

End: Time at end of trial.

ReactionTime: Reaction time in seconds.

Answer: Participant’s answer (which image they chose).

AnswerType: What type of answer the participant selected (correct, incorrect lure 1, incorrect lure 2, or novel foil). Note that there is no difference between incorrect lure 1 and incorrect lure 2 (both are old lures, or places that were previously shown but paired with a different animal; the 1 and 2 are randomly assigned).
