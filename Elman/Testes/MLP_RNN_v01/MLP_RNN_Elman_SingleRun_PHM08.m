%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BLA BLA BLA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   Navar de Medeiros Mendon�a e Nascimento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

data = csvread('../Conjunto de dados/data_op_01_cleaned.csv',1,1);
labels = csvread('../Conjunto de dados/data_op_01_cleaned_labels.csv',0,1);

A = [data, labels];

%%
[~, n_atributos] = size(data)

B = normalize(A, n_atributos,3);

Teste = normalize(A, n_atributos,3);

%% MLP hyperparameteres:
%==========================================================================
elman.inputs = n_atributos;
elman.outputNeurons = length(unique(A(:,end)));

elman.hiddenLayers = 1;
elman.hiddenSize = [50];

elman.ActivationFunction = {'Tanh', 'Tanh'};

elman.size = [elman.inputs, elman.hiddenSize, elman.outputNeurons];

%elman.lossFunction = 'Cross-entropy';
elman.lossFunction = 'MSE';

elman.learningRate = 0.1;
elman.momentumRate = 0.0;

elman.numTraining = 1;

elman.numEpochs = 500;

for n = 1:1:elman.hiddenLayers
    x0_buff = -1;             % Valor da entrada do BIAS -1 ou +1
    x0_h{n} = x0_buff;
end

elman.hiddenBias =  x0_h;

y0 = -1;

elman.outputBias = y0;

elman.dataNumAtributes = n_atributos;

elman.dataNumClasses = length(unique(A(:,end)));

elman

%% Separar dados em conjunto de treinamento e teste

%[Treino, Teste] = data_div5(B, 0.8);

elman.trainingData = B;

%% Fitting the model
                          
[elman.predict.w, elman.predict.m, elman.predict.weights,...
    elman.predict.e_treinamento, lupa] ...
              = elmanClf_fit_Start(elman, 0);
         
%% Predictions (Classifications)

output_elman = elmanClf_predict(elman, Teste);

%%

results = clfMetrics(labels, output_elman)

results.overall.confMat
        
figure;
plot(elman.predict.e_treinamento{1})
    
%%
figure_preset()
hold on


plot(lupa.m(end,:))
plot(lupa.w(end,:))
plot(lupa.gama_o(end,:))
plot(lupa.gama_h(end,:))

figure_postset()













    
















    



    