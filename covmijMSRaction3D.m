addpath('./libsvm-3-4.22/matlab')
datadir=('./data');
addpath('./MostJoint');

actionSet='ActionSet2.txt';
nofJoints=20;
noMostJoints =3;
noAction =20;
nLevels =3;
overlap =true;
timevar =false;
actionName = {'Wave','Hammer','Smash','Catch','Forward Punch','Throw','Draw X','Draw Tick','Draw Circle','Clapping Hand','Two hand Wave','Side Boxing','Bend','Forward Kick','Side Kick','Jogging','Tennis Swing','Tennis Serve','Golf Swing','Pickup&throw'};
file = fopen(actionSet,'r');
filename = cell(1,1);
h=1;
while ~feof(file)
    filename(h) = textscan(file,'%str\n');
    h =h+1;
end
fclose(file);
traindata =cell(2,1);
trainlabels = zeros(2,1);
testdata = cell(2,1);
testlabels =zeros(2,1);
listLabel =[];
di = 1; % counter for data
ti = 1;
len =size(filename,2);
A =cell(noAction,1);
matrixIndexJoint =zeros(noAction,noMostJoints);
traningsubjects =[1,3,5,7,9];
for i = 1:len
    if( ~isempty(find(traningsubjects == getSubject(char(filename{i})),1)));
        traindata{di} = load(fullfile(datadir,[char(filename{i}),'_skeleton3D.txt']));
        trainlabels(di) = getLabelAction(char(filename{i}));
        [n d] = size(traindata{di});
        noframes = n / nofJoints;
        x = reshape(traindata{di}(:,1), nofJoints, noframes); % x
        y = reshape(traindata{di}(:,2), nofJoints, noframes); % y
        z = reshape(traindata{di}(:,3), nofJoints, noframes);
        t = 1:noframes; % z
        listIdx = getMostJoints(x',y',z',1,noMostJoints);
        A{trainlabels(di)} = [A{trainlabels(di)};listIdx];
        di=di+1;
    else
        testdata{ti} =load(fullfile(datadir,[char(filename{i}),'_skeleton3D.txt']));
        testlabels(ti) = getLabelAction(char(filename{i}));
        ti = ti+1;   
    end
end
G = unique(trainlabels);
for k=1:length(G)
    % G(k)
    matrixIndexJoint(G(k),:) = getIdxMostJoints(A{G(k)},noMostJoints);
end
matrixIndexJoint
listLabel =unique(trainlabels);

% train with multi model  
model= cell(size(listLabel,1),1);
nofActionTrain =size(traindata,1);
fprintf('training \n');
for h=1:length(listLabel)
    fprintf('model %d\n',h)
    data_train=[];
    for i =1:nofActionTrain
        onetrain =traindata{i};
        % [n d]  = size(arr);
        noframes = size(onetrain,1) / nofJoints;
        x = reshape(traindata{i}(:,1),nofJoints,noframes);
        y = reshape(traindata{i}(:,2),nofJoints,noframes);
        z = reshape(traindata{i}(:,3),nofJoints,noframes);
        t =1:noframes;
        listJoints = matrixIndexJoint(listLabel(h),:);
        Xnew = x(sort(listJoints),:);
        Ynew = y(sort(listJoints),:);
        Znew = z(sort(listJoints),:);
         [fullCovmat,Covmat] = calculateCovMats(Xnew', Ynew', Znew', t', nLevels,overlap,timevar);
        % Covmat = calculateCovMats(Xnew', Ynew', Znew', t', nLevels,overlap);
        covMattoVector = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(Covmat, 1, []), 'UniformOutput', false));
        % normVec = normVec / (norm(normVec) + 1e-5);
        data_train =[data_train; covMattoVector];
        % size(rowdata3_train)
    end
    % model{g} =  TreeBagger(nTrees,rowdata3_train,double(labels ==listLabel(g)), 'Method', 'classification');
    %  model{g} = ClassificationTree.fit(rowdata3_train,double(labels == listLabel(g)));
        % [labelPr,Pr] = predict(trainmodel,dataTest);
     model{h}=svmtrain(double(trainlabels==listLabel(h)), data_train, '-c 10  -q -t 0 -b 1');
end
% test
fprintf('testing \n');
nofActionTest = size(testdata,1);
prob = zeros(nofActionTest,length(listLabel)); 
for k=1:length(listLabel)
    fprintf('model %d\n',k)
    data_test=[];
    for i =1:nofActionTest
        onetest = testdata{i};
        noframes = size(onetest,1)/ nofJoints;
        x = reshape(testdata{i}(:,1),nofJoints,noframes);
        y =reshape(testdata{i}(:,2),nofJoints,noframes);
        z =reshape(testdata{i}(:,3),nofJoints,noframes);
        t = 1: noframes;
        listJoints = matrixIndexJoint(listLabel(k),:);
        Xnew = x(sort(listJoints),:);
        Ynew = y(sort(listJoints),:);
        Znew = z(sort(listJoints),:);
         [fullCovmat,Covmat] = calculateCovMats(Xnew', Ynew', Znew', t', nLevels,overlap,timevar);
        % Covmat = calculateCovMats(Xnew', Ynew', Znew', t', nLevels,overlap);
        covMattoVector = cell2mat(cellfun(@(x)(cell2mat(x)), reshape(Covmat, 1, []), 'UniformOutput', false));
        % normVec = normVec / (norm(normVec) + 1e-5);
        data_test =[data_test;covMattoVector];
        % size(rowdata3_test)
    end
     [predict_label, accuracy, prob_estimates] = svmpredict(double(testlabels==listLabel(k)), data_test, model{k}, '-b 1 -q');
    % [labelPr,prob_estimates] = predict(model{k},rowdata3_test);
    % [labelPr,prob_estimates] = model{k}.predict(rowdata3_test);
    prob(:,k) = prob_estimates(:,model{k}.Label==1);  
    % prob_estimates(:,model{k}.Label==1)
    % prob_estimates(:,model{k}.Label==0)
    
     %# probability of class==k
    %  pause
end
[~,pred] = max(prob,[],2);
% for g=1:length(listLabel)
for j = 1 : numel(pred)
    % pred(pred == g) = listLabel(g);
    pred(j) = listLabel(pred(j));
end
size(data_train)
size(data_test)
size(testlabels)
size(trainlabels)
acc = sum(pred == testlabels) ./ numel(testlabels)
listF1 =[];
confMats = zeros(numel(listLabel));
for a1 = 1:numel(listLabel)
    num1 = sum( testlabels== listLabel(a1));
    if num1 == 0
        fprintf('tap test ko co action %d',a1);
        continue;
    end
    for a2 = 1:numel(listLabel)
        confMats(a1, a2) = sum(testlabels == listLabel(a1) &  pred== listLabel(a2));
    end
    confMats(a1, :) = confMats(a1, :) / num1;
end
figure; imagesctx(confMats,actionName(listLabel),actionName(listLabel),90);