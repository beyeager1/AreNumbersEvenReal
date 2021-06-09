%% Sternberg Working Memory %% 
% Brooke Yeager 
% Last edited by Brooke on 06/09/2021
% Last did: Made practice trials; changed font 

%% User input %%
UserInput = inputdlg({'Subject Number:','Triggers:','Practice or Testing:','Block Number:'},'Parameters',[1 35;1 35; 1 35; 1 35],{'','','',''}) ; 

SubjNum = str2num(UserInput{1}); 
Trigger = str2num(UserInput{2}); % 0 = No triggers, 1 = EEG triggers
PracOrTest = str2num(UserInput{3}); % 0 = Practice, 1 = Testing
BlockNum = str2num(UserInput{4}); % Put 1

Subject_ID=SubjNum;
block=BlockNum; % 0 = Practice trials; 1 = Working Memory Test trials

%% Brings up screen %%
    Screen('Preference', 'SkipSyncTests', 1);
    screens = Screen('Screens');
    whichscreen = max(screens);
    
    % screenRect = [0 0 800 600]; % for Debugging     
    % screenRect = [0 0 1280 720]; % for mirroring experiment with lower resolution computer myscreendow
     screenRect = []; % --> full screen for Experiment
    %screenRect = [0 0 1280 1000]; % --> almost full screen for Experiment on Windows with screen error

    [myscreen,rect] = Screen('Openwindow', whichscreen, [], screenRect); 

    HideCursor(); %hides the cursor

    black=BlackIndex(myscreen);
    Screen('FillRect',myscreen,black); % black screen
    Screen(myscreen, 'Flip');

    Screen('TextFont',myscreen,'Arial');  
    Screen('TextStyle',myscreen,0);
    Screen('TextColor',myscreen,[255 255 255]);
    Screen('TextSize',myscreen,50);
   [screenXpixels, screenYpixels] = Screen('WindowSize', myscreen);
    
%% Instructions %%
welcomeText1 = '\n\n Thank you for participating in this experiment. \n\n Please wait for the experimenter to tell you to begin.'
DrawFormattedText(myscreen,welcomeText1,'center','center');
Screen(myscreen, 'Flip');
KbWait([],3); % KbWait waits for key press to move on
    
instructionsText1 = '\n\n To begin, you will see a fixation cross (+). \n\n This will be followed by a list of letters. \n\n After the list, a short delay will occur which will be followed by a single letter. \n\n Your job is to determine if that letter was previously presented in the list of letters. \n\n If the letter was in the list, press "J". \n\n If the letter was NOT in the list, press "K". \n\n Please respond as quickly and accurately as you can. \n\n Once you are ready to start, press any key and the trials will begin.' ;
DrawFormattedText(myscreen, instructionsText1, 'center','center');
Screen(myscreen, 'Flip');
KbWait([],3);  % waits for keypress to move on   

%% Get keys %% 
KbName('UnifyKeyNames');
 k1 = KbName('j');   % for Matched
 k2 = KbName('k');   % for non-Matched  
 
%% Practice %%
if PracOrTest == 0
    PracTxt = '\n\nWe will start with some practice.\n\nPress any key to begin the practice.';
    DrawFormattedText(myscreen,PracTxt,'center','center',[255,255,255]);
    Screen(myscreen, 'Flip');
    KbWait([]);
    
    if block == 0
        numTrials=4;
        
    % Show fixation to start
    [X,Y] = RectCenter(rect);
    FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
    Screen('FillRect', myscreen, [0 1 0])
    Screen('FillRect', myscreen, [255,255,255], FixCross');
    Screen('Flip', myscreen);
    WaitSecs(2)
    
    %1= Match; 2= Not match with target
    SameTrials=[ones(1,numTrials/2) (ones(1,numTrials/2)*2)] %Matrix with equal number of conditions
    condition=SameTrials(1,randperm(length(SameTrials))) %Shuffle the conditions
    condition = condition';
    
    %1= 3 letter string stimuli; 2= 6 letter string stimuli
    StimTypePrac=[ones(1,numTrials/2) (ones(1,numTrials/2)*2)] %Matrix with equal number of conditions
    condition2=StimTypePrac(1,randperm(length(StimTypePrac))) %Shuffle the conditions
    condition2 = condition2';
    
    %% Load stimuli
    load('PRACTICEStim6.mat') % load 6 letter target stimuli
    load('PRACTICEStimCells6.mat') % load 6 letter probe stimuli
    load('PRACTICEStim3.mat') % load 3 letter target stimuli
    load('PRACTICEStimCells3.mat') % load 3 letter probe stimuli
    
    %% Practice Loop
    for i = 1:numTrials
        
    fixationTime = 3
    WaitSecs(fixationTime)   
    
    %% Stim type 'if' statement for PRACTICE
        if condition2(i) == 1 % Pulls 3 letter stimuli
            Screen('TextSize',myscreen,150); % Pull letter strings from cell array to display %
            DrawFormattedText(myscreen, PracStim2{i,1}, 'center', 'center', [255,255,255]);
            Screen('Flip', myscreen);
            WaitSecs(3)

        elseif condition2(i) == 2 % Pulls 6 letter stimuli
            Screen('TextSize',myscreen,150); % Pull letter strings from cell array to display %
            DrawFormattedText(myscreen, PracStim{i,1}, 'center', 'center', [255,255,255]);
            Screen('Flip', myscreen);
            WaitSecs(3)
        end
    
    %%%Show fixation between trials 
    [X,Y] = RectCenter(rect);
    FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
    Screen('FillRect', myscreen, [0 1 0])
    Screen('FillRect', myscreen, [255,255,255], FixCross');
    Screen('Flip', myscreen);
    ITI = 2 + (5.0 - 2.0).*rand(1);
    WaitSecs(ITI) %%Random internal between 2 and 5 seconds

    %% Making a randomized letter target trial for Probe trials
    % Create alphabet array
    alphabet1 = {'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'Q' 'R' 'S' 'T' 'V' 'W' 'X' 'Z'}
    % Random alphabet array
    randomize1 = randperm(length(alphabet1))
    randAlphabet1 = alphabet1(randomize1)

    %% Probe trials %%
        if condition2(i) == 1
            trialArray1 = PracStimCells2(i,:);
            msize2 = numel(trialArray1);
            probeLetter = trialArray1(randperm(msize2, 1));
            str2 = string(probeLetter);
            iBase2 = 1;
            probe = cellfun(@(str2)str2(iBase2),str2); % Probe needs to be one of letters from trialArray1
            responseData(i,4) = probeLetter;

            if condition(i) == 2 % If trial type is non-matched
                while ismember(cell2mat(probeLetter), trialArray1)
                    msize2 = numel(randAlphabet1);
                    probeLetter = randAlphabet1(randperm(msize2, 1));
                    str2 = string(probeLetter);
                    iBase2 = 1;
                    probe = cellfun(@(str2)str2(iBase2),str2);
                    responseData(i,4) = probeLetter;
                end
            end     

        elseif condition2(i) == 2
            trialArray1 = PracStimCells(i,:);
            msize2 = numel(trialArray1);
            probeLetter = trialArray1(randperm(msize2, 1));
            str2 = string(probeLetter);
            iBase2 = 1;
            probe = cellfun(@(str2)str2(iBase2),str2); % Probe needs to be one of letters from trialArray1
            responseData(i,4) = probeLetter;

            if condition(i) == 2 % If trial type is non-matched
                while ismember(cell2mat(probeLetter), trialArray1)
                    msize2 = numel(randAlphabet1);
                    probeLetter = randAlphabet1(randperm(msize2, 1));
                    str2 = string(probeLetter);
                    iBase2 = 1;
                    probe = cellfun(@(str2)str2(iBase2),str2);
                    responseData(i,4) = probeLetter;
                end
            end 
        end
        
        %%% Set stimulus size as 150
        startTime = GetSecs;
        Screen('TextSize',myscreen,150);
        DrawFormattedText(myscreen, probe, 'center','center', [255,255,255]);
        Screen('Flip', myscreen);

        % If no response after 2 seconds move on   
        timelimit=2;

        timedout = false;
            while ~timedout
            % check if a key is pressed
            [ keyIsDown, keyTime, keyCode ] = KbCheck; 
                if(keyIsDown), break; end       
              if( (keyTime - startTime) > timelimit), timedout = true; end        
            end   
    
        % Let them know if their response is too slow! (i.e., > 2 sec.)
        if(timedout)
            Screen('TextSize',myscreen,100);
            DrawFormattedText(myscreen, 'Too slow! Please respond faster.', 'center','center',[255,255,255]);
            Screen('Flip', myscreen); 
            WaitSecs(2);  
        end
    
        if(~timedout)
    
            %% Accuracy %%
            if condition(i) == 1 && (keyCode(k1) == 1)
                                   Acc_feedback = 'Correct!';
                                   Acc = 1;
                      elseif condition(i) == 2 && (keyCode(k2) == 1)
                                   Acc_feedback = 'Correct!';
                                   Acc = 1;
                      else
                                   Acc_feedback = 'Incorrect!';
                                   Acc = 0;
            end 

            if Acc == 1 
                %Feedback_text = [Acc_feedback];
                Screen('TextSize',myscreen,150);
                DrawFormattedText(myscreen,Acc_feedback,'center','center', [0,255,0]);
                vbl=Screen(myscreen, 'Flip'); % Swaps backbuffer to frontbuffer
                Screen(myscreen, 'Flip',vbl+2); % Erases feedback after 2 second
                Acc_feedback

            elseif Acc == 0 
                Screen('TextSize',myscreen,150);
                DrawFormattedText(myscreen,Acc_feedback,'center','center', [255,0,0]); 
                vbl=Screen(myscreen, 'Flip'); % Swaps backbuffer to frontbuffer
                Screen(myscreen, 'Flip',vbl+2); % Erases feedback after 2 second

            end
        end
    
        % End each trial with a fixation cross for 3 seconds
        [X,Y] = RectCenter(rect);
        FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
        Screen('FillRect', myscreen, [0 1 0])
        Screen('FillRect', myscreen, [255,255,255], FixCross');
        Screen('Flip', myscreen);
        WaitSecs(0)    
    
clear startTime rawTime keyCode
    end 
    
    %% The end %%
        Screen('TextSize',myscreen,65);
        DrawFormattedText(myscreen, 'Practice is over! Any questions?', 'center','center',[255, 255, 255]);
        Screen(myscreen,'Flip');
        WaitSecs(3);
        Screen('CloseAll')
        
    end

elseif PracOrTest==1
    
    %% Set up %% 
    if block==1
        numTrials=60; %number of trials

    % Show fixation to start
    [X,Y] = RectCenter(rect);
    FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
    Screen('FillRect', myscreen, [0 1 0])
    Screen('FillRect', myscreen, [255,255,255], FixCross');
    Screen('Flip', myscreen);
    WaitSecs(3)      
    
    %1= Match; 2= Not match with target
    SameTrials=[ones(1,numTrials/2) (ones(1,numTrials/2)*2)] %Matrix with equal number of conditions
    condition=SameTrials(1,randperm(length(SameTrials))) %Shuffle the conditions
    condition = condition';
    
    %1= 3 letter string stimuli; 2= 6 letter string stimuli
    StimType=[ones(1,numTrials/2) (ones(1,numTrials/2)*2)] %Matrix with equal number of conditions
    condition2=StimType(1,randperm(length(StimType))) %Shuffle the conditions
    condition2 = condition2';

%% Set up blank storage matrix for data storage %%
% Column 1: Trial #
% Column 2: Trial type -- matched = 1, non-matched = 2
% Column 3: Target trial
% Column 4: Probe trial
% Column 5: Key press
% Column 6: Key code
% Column 7: Accuracy
% Column 8: Accuracy feedback
% Column 9: RT (ms)
% Column 10: Stimulus type -- 3 letter stimulus = 1; 6 letter stimulus = 2
responseData = cell(numTrials, 10);
responseData(:,1) = num2cell(1:numTrials) %First column is Trial number

load('TargStim6.mat') % load 6 letter target stimuli
load('TargStimCells6.mat') % load 6 letter probe stimuli
load('TargStim3.mat') % load 3 letter target stimuli
load('TargStimCells3.mat') % load 3 letter probe stimuli

responseData(i,2) = num2cell(condition(i)); %Column 2: Trial type -- matched = 1, non-matched = 2
responseData(:,10) = num2cell(condition2) %Column 10: Stim type == 3 letter = 1, 6 letter = 2 

    %% Testing loop
    for i = 1:numTrials
  
    fixationTime = 3
    WaitSecs(fixationTime)

        if i==30
           Screen('TextSize',myscreen,65);
           breakText = '\n\n You are halfway done! \n\n Please take a minute or two to rest if you need. \n\n Press any key to keep going.'
           DrawFormattedText(myscreen,breakText,'center','center', [255, 255, 255]);
           Screen(myscreen, 'Flip');
           KbWait([],3); 

           [X,Y] = RectCenter(rect);
            FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
            Screen('FillRect', myscreen, [0 1 0])
            Screen('FillRect', myscreen, [255,255,255], FixCross');
            Screen('Flip', myscreen);
            WaitSecs(3) 
        end
        
        %% Stim type 'if' statement
        if condition2(i) == 1 % Pulls 3 letter stimuli
            Screen('TextSize',myscreen,150); % Pull letter strings from cell array to display %
            DrawFormattedText(myscreen, TargStim2{i,1}, 'center', 'center', [255,255,255]);
            Screen('Flip', myscreen);
                        if Trigger == '0'
                            disp('EEGtrigger S1')
                        elseif Trigger == '1'
                            EEGtrigger(1)
                        end
            WaitSecs(3)
            responseData(i,3) = cellstr(TargStim2{i,1});

        elseif condition2(i) == 2 % Pulls 6 letter stimuli
            Screen('TextSize',myscreen,150); % Pull letter strings from cell array to display %
            DrawFormattedText(myscreen, TargStim{i,1}, 'center', 'center', [255,255,255]);
            Screen('Flip', myscreen);
                        if Trigger == '0'
                            disp('EEGtrigger S2')
                        elseif Trigger == '1'
                            EEGtrigger(2)
                        end
            WaitSecs(3)
            responseData(i,3) = cellstr(TargStim{i,1});
        end  
        
        %%%Show fixation between trials
            [X,Y] = RectCenter(rect);
            FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
            Screen('FillRect', myscreen, [0 1 0])
            Screen('FillRect', myscreen, [255,255,255], FixCross');
            Screen('Flip', myscreen);
            ITI = 2 + (5.0 - 2.0).*rand(1);
            WaitSecs(ITI) %%Random internal between 2 and 5 seconds

        %% Making a randomized letter target trial for Probe trials
        % Create alphabet array
        alphabet1 = {'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'Q' 'R' 'S' 'T' 'V' 'W' 'X' 'Z'}
        % Random alphabet array
        randomize1 = randperm(length(alphabet1))
        randAlphabet1 = alphabet1(randomize1)

        %% Probe trials %%
        if condition2(i) == 1
            trialArray1 = TargStimCells2(i,:);
            msize2 = numel(trialArray1);
            probeLetter = trialArray1(randperm(msize2, 1));
            str2 = string(probeLetter);
            iBase2 = 1;
            probe = cellfun(@(str2)str2(iBase2),str2); % Probe needs to be one of letters from trialArray1
            responseData(i,4) = probeLetter;

            if condition(i) == 2 % If trial type is non-matched
                while ismember(cell2mat(probeLetter), trialArray1)
                    msize2 = numel(randAlphabet1);
                    probeLetter = randAlphabet1(randperm(msize2, 1));
                    str2 = string(probeLetter);
                    iBase2 = 1;
                    probe = cellfun(@(str2)str2(iBase2),str2);
                    responseData(i,4) = probeLetter;
                end
            end     

        elseif condition2(i) == 2
            trialArray1 = TargStimCells(i,:);
            msize2 = numel(trialArray1);
            probeLetter = trialArray1(randperm(msize2, 1));
            str2 = string(probeLetter);
            iBase2 = 1;
            probe = cellfun(@(str2)str2(iBase2),str2); % Probe needs to be one of letters from trialArray1
            responseData(i,4) = probeLetter;

            if condition(i) == 2 % If trial type is non-matched
                while ismember(cell2mat(probeLetter), trialArray1)
                    msize2 = numel(randAlphabet1);
                    probeLetter = randAlphabet1(randperm(msize2, 1));
                    str2 = string(probeLetter);
                    iBase2 = 1;
                    probe = cellfun(@(str2)str2(iBase2),str2);
                    responseData(i,4) = probeLetter;
                end
            end 
        end
            
        %%% Set stimulus size as 150
        startTime = GetSecs;
        Screen('TextSize',myscreen,150);
        DrawFormattedText(myscreen, probe, 'center','center', [255,255,255]);
        Screen('Flip', myscreen);
                if condition(i) == 1
                    if Trigger == '0'
                        disp('EEGtrigger S3')
                    elseif Trigger == '1'
                        EEGtrigger(3)
                    end
                elseif condition(i) == 2
                        if Trigger == '0'
                        disp('EEGtrigger S4')
                    elseif Trigger == '1'
                        EEGtrigger(4)
                        end
                end

        % If no response after 2 seconds move on   
        timelimit=2;
     
        timedout = false;
            while ~timedout
            % Check if a key is pressed
            [ keyIsDown, keyTime, keyCode ] = KbCheck; 
                if(keyIsDown), break; end       
              if( (keyTime - startTime) > timelimit), timedout = true; end        
            end   

        % Send response trigger
        if keyCode(k1)==1
            if Trigger == '0'
                disp('EEGtrigger S5')
            elseif Trigger == '1'
                EEGtrigger(5)
            end 
        elseif keyCode(k2)==1
            if Trigger == '0'
                disp('EEGtrigger S6')
            elseif Trigger == '1'
                EEGtrigger(6)
            end 
        end
    
        % Let them know if their response is too slow! (i.e., > 2 sec.)
        if(timedout)
            Screen('TextSize',myscreen,100);
            DrawFormattedText(myscreen, 'Too slow! Please respond faster.', 'center','center',[255,255,255]);
            Screen('Flip', myscreen); 
            WaitSecs(2);

            responseData{i,5} = 0
            responseData{i,6} = 0 
            responseData{i,7} = 0
            TimedOutText = 'Timed out';
            responseData{i,8} = string(TimedOutText)
            responseData{i,9} = 9999
                if Trigger == '0'
                    disp('EEGtrigger S99')
                elseif Trigger == '1'
                    EEGtrigger(99)
                end 
        end
    
        if(~timedout)
            responseData{i,9} = keyTime - startTime;  %RT data
        %Response type/ key press data
            if keyCode(k1)==1
                responseData{i,5} = 1;
            elseif keyCode(k2)==1
                responseData{i,5} = 2;
            end

        responseData{i,6} = find(keyCode == 1); % actual key code in case a different key than 'j' or 'k' is pressed
    
        %% Accuracy %%
        if condition(i) == 1 && (keyCode(k1) == 1)
                               Acc_feedback = 'Correct!';
                               Acc = 1;
                  elseif condition(i) == 2 && (keyCode(k2) == 1)
                               Acc_feedback = 'Correct!';
                               Acc = 1;
                  else
                               Acc_feedback = 'Incorrect!';
                               Acc = 0;
        end
        responseData{i,7} = Acc;
        responseData{i,8} = string(Acc_feedback); 

        if Acc == 1 
            %Feedback_text = [Acc_feedback];
            Screen('TextSize',myscreen,150);
            DrawFormattedText(myscreen,Acc_feedback,'center','center', [0,255,0]);
            vbl=Screen(myscreen, 'Flip'); % Swaps backbuffer to frontbuffer
            Screen(myscreen, 'Flip',vbl+2); % Erases feedback after 2 second
            Acc_feedback

        elseif Acc == 0 
            Screen('TextSize',myscreen,150);
            DrawFormattedText(myscreen,Acc_feedback,'center','center', [255,0,0]); 
            vbl=Screen(myscreen, 'Flip'); % Swaps backbuffer to frontbuffer
            Screen(myscreen, 'Flip',vbl+2); % Erases feedback after 2 second

        end
        end
    
        % End each trial with a fixation cross for 3 seconds
        [X,Y] = RectCenter(rect);
        FixCross = [X-1,Y-40,X+1,Y+40;X-40,Y-1,X+40,Y+1]
        Screen('FillRect', myscreen, [0 1 0])
        Screen('FillRect', myscreen, [255,255,255], FixCross');
        Screen('Flip', myscreen);
        WaitSecs(0)    
    
clear startTime rawTime keyCode
    end

%% Save data %%
csvwrite('test.csv',RespInfoPractice);

%% The end %%
  Screen('TextSize',myscreen,65);
        DrawFormattedText(myscreen, 'That is all! Thanks for participating!', 'center','center',[255, 255, 255]);
        Screen(myscreen,'Flip');
        WaitSecs(3);
        Screen('CloseAll')
    end
end


 