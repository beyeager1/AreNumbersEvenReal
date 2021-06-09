%% Make a predetermined list of 6 letter string orders for Practice trials
pracTrials = 8

practest = cell(pracTrials, 1);

% 6 letter stimuli
for i = 1:(pracTrials/2)
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

save('PRACTICEStim6.mat', 'PracStim') % how to save the variable for later use
save('PRACTICEStimCells6.mat', 'PracStimCells')

% 3 letter stimuli
for i = 1:(pracTrials/2)
    alphabet = {'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'Q' 'R' 'S' 'T' 'V' 'W' 'X' 'Z'}
    randomize = randperm(length(alphabet));
    randAlphabet = alphabet(randomize);
    msize = numel(randAlphabet);
    trialArray = randAlphabet(randperm(msize, 3));
    strings = string(trialArray);
    iBase = 1;
    targTrial = cellfun(@(strings)strings(iBase),strings);
    PracStim2{i,1} = targTrial
    PracStimCells2(i,1:3) = trialArray
end

PracStim2 = PracStim2(:); %Make the list a variable in order to save this specific list of letter strings
PracStimCells2 = PracStimCells2

save('PRACTICEStim3.mat', 'PracStim2') % how to save the variable for later use
save('PRACTICEStimCells3.mat', 'PracStimCells2')

%% Make a predetermined list of 60 letter string orders for Testing trials %%
numTrials = 120

test = cell(numTrials, 1);

for i = 1:(numTrials/2)
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

save('TargStim6.mat', 'TargStim')
save('TargStimCells6.mat', 'TargStimCells')

for i = 1:(numTrials/2)
    alphabet1 = {'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'Q' 'R' 'S' 'T' 'V' 'W' 'X' 'Z'}
    randomize2 = randperm(length(alphabet1));
    randAlphabet2 = alphabet1(randomize2);
    msize2 = numel(randAlphabet2);
    trialArray2 = randAlphabet2(randperm(msize2, 3));
    str2 = string(trialArray2);
    iBase2 = 1;
    targTrial2 = cellfun(@(str2)str2(iBase2),str2);
    TargStim2{i,1} = targTrial2
    StimCells2(i,1:3) = trialArray2
end

TargStim2 = TargStim2(:); %Make the list a variable in order to save this specific list of letter strings
TargStimCells2 = StimCells2;

save('TargStim3.mat', 'TargStim2')
save('TargStimCells3.mat', 'TargStimCells2')
