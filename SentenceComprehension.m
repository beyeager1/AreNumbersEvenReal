% Last edited by Brooke Yeager on 07/28/2021
% Added EEG triggers; Added a cue to let subjects know their response has
% been recorded; Added a data structure; Triggers now reflect the stimulus
% type

close all; clearvars; warning off; clc;
%% Stimuli are from Rutvik Desai paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3131459/

%% Get the experiment inputs 
UserInput = inputdlg({'Subject Number: (10XX)', 'Enter Stimulation Condition: (1, 2, 3)', 'Stimuli List: (1, 2 ,3)', 'Triggers: (0 = No, 1 = Yes)'}, 'Parameters',[1 35;1 35;1 35;1 35],{'','','',''}) ; 
SubjNum = str2num(UserInput{1}) ;  
StimCond = str2num(UserInput{2}); 
ListNum=str2num(UserInput{3});
Triggers = str2num(UserInput{4}); 

Subject_ID=SubjNum; % 10XX; where XX is replaced by a number 1-99
Stimulation=StimCond; % 1=Sham ; 2=Tuned ; 3=Non-tuned
List=ListNum; % Lists of stimuli; to be counterbalanced across subjects
Trig=Triggers; % 0 = No triggers, 1 = EEG triggers

%% EEG Triggers and Setting Port
if Triggers == 1
    %%%%% for serial trigger using matlab functions
    instrreset % %%%%Disconnect and delete all instrument objects
    SPO = serial('COM4', 'TimeOut', 1); % in this example x=3
    % To connect the serial port object with serial port hardware
    fopen(SPO);
    % Set the port to zero state 0
    fwrite(SPO, 0,'sync');
end

%% Set up data output
responseData = cell(104, 7);
responseData(:,1) = num2cell(1:104); %First column is Trial number

%% Here load list for the stimulation session; these are on the Counterbalancing excel sheet
if List==1
    [numbers, TEXT, everything] = xlsread('StimuliRandomization.xlsx','List1'); %read stimuli
elseif List==2
    [numbers, TEXT, everything] = xlsread('StimuliRandomization.xlsx','List2'); %read stimuli
else
   [numbers, TEXT, everything] = xlsread('StimuliRandomization.xlsx','List3'); %read stimuli
end
    
% Read stimuli type
for i=1:size(TEXT,1)
 type=TEXT{i,2};
 Sen_type{i}=type;
end

for i=1:size(TEXT,1)
 Stimuli=TEXT{i,1};
 Stimuli_index{i}=Stimuli;
end

%%%Randomize sentences
numTrials=108;
StimuliOrder=Shuffle(Stimuli_index);

responseData(:,2)=StimuliOrder';

%% Screen set-up
  Screen('Preference', 'SkipSyncTests', 1);

  screens = Screen('Screens');
    whichscreen = max(screens);
    
    % screenRect = [0 0 800 600]; % for Debugging     
    % screenRect = [0 0 1280 720]; % for mirroring experiment with lower resolution computer myscreendow
     screenRect = []; % --> full screen for Experiment
      %screenRect = [0 0 1280 1000]; % --> almost full screen for Experiment on Windows with screen error

    [myscreen,rect] = Screen('Openwindow', whichscreen, [], screenRect); 

   %HideCursor(); %hides the cursor

    black=BlackIndex(myscreen);
    Screen('FillRect',myscreen,black); % black screen
    Screen(myscreen, 'Flip');

    Screen('TextFont',myscreen,'Arial');  
    Screen('TextStyle',myscreen,0);
    Screen('TextColor',myscreen,[255 255 255]);
    Screen('TextSize',myscreen,40);
   [screenXpixels, screenYpixels] = Screen('WindowSize', myscreen);
   
[ keyIsDown, keyTime, keyCode ] = KbCheck;
   
%% Instructions
welcomeText1 = '\n\n Thank you for participating in this experiment!';
DrawFormattedText(myscreen,welcomeText1,'center','center');
Screen(myscreen, 'Flip');
KbWait([],3); % KbWait waits for key press to move on

instructionsText1 = '\n\n A fixation cross will appear in the center of your screen. \n\n Try to maintain your gaze on the fixation cross throughout the task. \n\n In this task you will hear a series of sentences that will be read aloud to you. \n\n Your job is to determine if the sentence makes logical sense or not. \n\n Some of the sentences will be abstract or metaphoric but will still make logical sense. \n\n If you think the sentence makes logical sense, press "J" on the keyboard. \n\n If the sentence does not make logical sense press "K" on the keyboard. \n\n Press any key to begin.';
DrawFormattedText(myscreen, instructionsText1, 'center','center');
Screen(myscreen, 'Flip');
KbWait([],3);  % waits for keypress to move on   

%Set key presses
k1 = KbName('J');   % for Matched
k2 = KbName('K');   % for non-matched      

%%Change directory for stimuli
cd 'C:\Users\beyeager\Documents\Research\tACS-EEG\Tasks\Sentence Comprehension\Stimuli'

%% Start task
for i = 1:10 %size(StimuliOrder,2)
    %%Load audio files
    Sentence2play=cell2mat(StimuliOrder(i));
    [N,Fs] = audioread([Sentence2play '.mp3']);
    fixationTime=size(N,1)/Fs;
    
    Trialtype=cell2mat(StimuliOrder(i));
        if any(strcmp(Trialtype(1), 'L' ))
            if Triggers == 0
                disp('EEGtrigger S1')
                elseif Triggers == 1
                EEGtrigger(SPO,1)
            end
        elseif any(strcmp(Trialtype(1), 'M' ))
            if Triggers == 0
                disp('EEGtrigger S2')
                elseif Triggers == 1
                EEGtrigger(SPO,2)
            end
        elseif any(strcmp(Trialtype(1), 'A' ))
            if Triggers == 0
                disp('EEGtrigger S3')
                elseif Triggers == 1
                EEGtrigger(SPO,3)
            end
        elseif any(strcmp(Trialtype(1), 'N' ))
            if Triggers == 0
                disp('EEGtrigger S4')
                elseif Triggers == 1
                EEGtrigger(SPO,4)
            end
        end
        
    %Show fixation
    [X,Y] = RectCenter(rect);
    FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1];
    Screen('FillRect', myscreen, [0 1 0])
    Screen('FillRect', myscreen, [255,255,255], FixCross');
    Screen('Flip', myscreen);
    sound(N,Fs)
    WaitSecs(fixationTime)
    
%% Timed Out 
% If no response after 2 seconds move on   
timelimit=2; %seconds
startTime = GetSecs;
     
timedout = false;
    while ~timedout
    % check if a key is pressed
    [ keyIsDown, keyTime, keyCode ] = KbCheck; 
      if(keyIsDown), 
          Screen('TextSize',myscreen,75);
            DrawFormattedText(myscreen, 'Response recorded!', 'center','center',[255,255,255]);
            Screen('Flip', myscreen); 
            WaitSecs(1);
            break; 
      end
      if( (keyTime - startTime) > timelimit), timedout = true; end
    end   
        
        % Response Triggers 
        if keyCode(k1)==1
            if Triggers == 0
                disp('EEGtrigger S5')
            elseif Triggers == 1
                EEGtrigger(SPO,5)
            end 
        elseif keyCode(k2)==1
            if Triggers == 0
                disp('EEGtrigger S6')
            elseif Triggers == 1
                EEGtrigger(SPO,6)
            end 
        end
        
        %Response type/ key press data
            if keyCode(k1)==1
                responseData{i,5} = 1;
            elseif keyCode(k2)==1
                responseData{i,5} = 2;
            end
    
% Let them know if their response is too slow! (i.e., > 2 sec.)
    if(timedout)
        Screen('TextSize',myscreen,75);
        DrawFormattedText(myscreen, 'Too slow! Please respond faster.', 'center','center',[255,255,255]);
        Screen('Flip', myscreen); 
        WaitSecs(2);
            if Triggers == 0
                disp('EEGtrigger S99')
            elseif Triggers == 1
                EEGtrigger(SPO,99)
            end 
        % Timed out responses for data structure
        responseData{i,3}= 9999; %9999 seconds RT for timed out trials 
        responseData{i,4}= 0; % Accuracy is 0 if timed out
        responseData{i,5}= 0; % 0 for no key press of J or K
        responseData{i,6}= 0; % 0 for no key press
    end
    
    responseData{i,6} = find(keyCode == 1); % actual key code in case a different key than 'j' or 'k' is pressed
%% Accuracy
    Trialtype=cell2mat(StimuliOrder(i));
    if any(strcmp(Trialtype(1), 'L' )) && (keyCode(k1)==1) ||...
        any(strcmp(Trialtype(1), 'M' )) && (keyCode(k1)==1) ||...
        any(strcmp(Trialtype(1), 'A' )) && (keyCode(k1)==1) ||...
        any(strcmp(Trialtype(1), 'N' )) && (keyCode(k2)==1) 
        Acc = 1;
        responseData{i,4}=Acc;
    else
        Acc = 0;
        responseData{i,4}=Acc;
    end
    Accuracy(i)=Acc;
    
%% Reaction time
Response = keyTime - startTime;   
RT(i)=Response;
responseData{i,3}=Response;

ITI=rand(1)*(2-1.5)+1.5;
WaitSecs(ITI);

end 

%% Save data %%
task=['SentComp_' 'StimType' num2str(StimCond) '_' num2str(SubjNum) '.mat']
save(task, 'responseData')

%% The end %%
  Screen('TextSize',myscreen,60);
        DrawFormattedText(myscreen, 'That is all! Thanks for participating!', 'center','center',[255, 255, 255]);
        Screen(myscreen,'Flip');
        WaitSecs(3);
        Screen('CloseAll')
        
sca% close screen
%%