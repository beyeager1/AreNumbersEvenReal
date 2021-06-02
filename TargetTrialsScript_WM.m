%% Make a predetermined list of 6 letter string orders for Practice trials
pracTrials = 4

practest = cell(pracTrials, 1);

for i = 1:pracTrials
    alphabet = {'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'Q' 'R' 'S' 'T' 'V' 'W' 'X' 'Z'}
    randomize = randperm(length(alphabet));
    randAlphabet = alphabet(randomize);
    msize = numel(randAlphabet);
    trialArray = randAlphabet(randperm(msize, 6));
    strings = string(trialArray);
    iBase = 1;
    targTrial = cellfun(@(strings)strings(iBase),strings);
    PracStim{i,1} = targTrial
    PracStimCells(i,1:6) = trialArray
end

PracStim = PracStim(:); %Make the list a variable in order to save this specific list of letter strings
PracStimCells = PracStimCells

% Save stimuli
save('PRACTICEStim.mat', 'PracStim') % how to save the variable for later use
save('PRACTICEStimCells.mat', 'PracStimCells')

%% Make a predetermined list of 60 letter string orders for Testing trials %%
numTrials = 60

test = cell(numTrials, 1);

for i = 1:numTrials
    alphabet1 = {'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'Q' 'R' 'S' 'T' 'V' 'W' 'X' 'Z'}
    randomize1 = randperm(length(alphabet1));
    randAlphabet1 = alphabet1(randomize1);
    msize1 = numel(randAlphabet1);
    trialArray1 = randAlphabet1(randperm(msize1, 6));
    str1 = string(trialArray1);
    iBase1 = 1;
    targTrial1 = cellfun(@(str1)str1(iBase1),str1);
    TargStim{i,1} = targTrial1
    StimCells(i,1:6) = trialArray1
end

TargStim = TargStim(:); %Make the list a variable in order to save this specific list of letter strings
TargStimCells = StimCells;

% Save stimuli
save('TargStim.mat', 'TargStim') % how to save the variable for later use
save('TargStimCells.mat', 'TargStimCells')