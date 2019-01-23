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
DataRaw = load("../Conjunto de dados/train.txt");
DataRaw_teste = load("../Conjunto de dados/test.txt");
%% Separate data per unit:
% Each unit is a motor part
% collum 1 is the number of part
% collum 2 is the time
% collum 3,4 and 5 are operational settings
% collum 6 to 26 are different sensors measuments

A.unit = data_slicer(DataRaw, 1);
C.unit = data_slicer(DataRaw_teste, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Normalizar os dados
unitNum = 1;

B = [A.unit{1}(:,6) ones(length(A.unit{unitNum}(:,6)),1)]

rotules(1:length(C.unit{unitNum}(:,6)),1) = -1;
Teste = [C.unit{1}(:,6) rotules]

[n_amostras, n_atributos, n_classes, n_amostras_c, pos] = info_dados(B)

% B = A;
B = normalize(B, n_atributos,1);

Teste = normalize(B, n_atributos,1);

%% MLP hyperparameteres:
%==========================================================================
mlp.inputs = 1;
mlp.outputNeurons = 1;

mlp.hiddenLayers = 1;
mlp.hiddenSize = [5];

mlp.ActivationFunction = {'Tanh', 'Tanh'};

mlp.size = [mlp.inputs, mlp.hiddenSize, mlp.outputNeurons];

%mlp.lossFunction = 'Cross-entropy';
mlp.lossFunction = 'MSE';

mlp.learningRate = 0.3;
mlp.momentumRate = 0.5;

mlp.numTraining = 1;

mlp.numEpochs = 1;

for n = 1:1:mlp.hiddenLayers
    x0_buff = -1;             % Valor da entrada do BIAS -1 ou +1
    x0_h{n} = x0_buff;
end

mlp.hiddenBias =  x0_h;

y0 = -1;

mlp.outputBias = y0;

mlp.dataNumAtributes = 1;

mlp.dataNumClasses = 1;

mlp

%% Separar dados em conjunto de treinamento e teste

%[Treino, Teste] = data_div5(B, 0.8);

mlp.trainingData = B;

%% Fitting the model
                          
[mlp.predict.w, mlp.predict.m, mlp.predict.weights,...
    mlp.predict.e_treinamento] ...
              = elmanClf_fit(mlp, 0);
         
%% Predictions (Classifications)

for k=1:1:mlp.hiddenLayers
   mlp.predict.w{1}{k} 
end

output_elman = elmanClf_predict(mlp, Teste);

rateAcerto

%%
%figure
%%plot(mlp.predict.e_g_treinamento{1}, 'r')

a = min(Teste(:,1));
b = max(Teste(:,1));

%%y_gain = y.* (y'./(Teste(:,1)))
%y_gain = (y - min(Teste(:,1)) )./ gain
%y_gain = y ./ length(y)
Teste_gain = normalize(Teste,1,2);

y_gain = [y' ones(length(y),1)]
y_gain = normalize(y_gain,1,2)

figure
hold on
plot(Teste_gain(:,1), 'k', 'LineWidth', 2)
plot(y_gain(:,1), 'r--', 'LineWidth', 2)
        
        
    
    
















    



    