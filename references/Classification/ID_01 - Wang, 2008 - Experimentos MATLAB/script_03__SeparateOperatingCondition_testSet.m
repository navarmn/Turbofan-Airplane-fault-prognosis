%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to replicate figure and results from:
% ID_01 - Wang, 2008 - IEEE - A Similarity-Based Prognostics Approach for
%           Remaining Useful Life Estimation of Engineered Systems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc
close all
clear all
%%

Data = load("/media/navar/Dados/Mestrado/Mestrado/MP-Safety ITA/Conjuntos de dados/PHM08 - NASA/Conjunto de dados/test.txt");

%% Separate data per unit:
% Each unit is a motor part
% collum 1 is the number of part
% collum 2 is the time
% collum 3,4 and 5 are operational settings
% collum 6 to 26 are different sensors measuments

data.unit = data_slicer(Data, 1);
A = data;

%% Plot clusters from operational settings:
% Section IV-A-1: Operating regime partitioning

clusters = [];
for i = 1:length(A.unit)
   
    clusters = [clusters; A.unit{i}(:,[3,4,5])];
    
end

clusters(:,end+1) = 1;

figure_preset();
plotDataset(clusters, 1,2,3)

figure_postset();

xlabel('Altitude')
ylabel('Mach number')
zlabel('Throttle Resolver Angle')
grid on

% label data by its cluster using euclidian distance:

vectors = {[10.01, 0.2511, 20];
           [20, 0.702, 0];
           [0.0024, 0.001, 100];
           [42, 0.84, 40];
           [20, 0.702, 0];
           [25, 0.621, 80]};

for i = 1:length(A.unit)
    [lin, col] = size(A.unit{i});
    for j = 1:lin
        for k = 1:length(vectors)
    
            distances(k) = norm(A.unit{i}(j,[3,4,5]) - vectors{k});
    
        end
        
        [~, label] = min(distances);
        A.unit{i}(j,col+1) = label;
    end
end

%% Rearange cycle index and plot sensor readings.
% Section IV-A-2: Sensor selection

for i = 1:length(A.unit)
   
    A.unit{i}(:,2) = A.unit{i}(:,2) - max(A.unit{i}(:,2));
    
end

%% Separate by operating conditions and create 4 classes
% concatenate all units:
operating_idx = 2;
sensor_idx = [2,3,4,7,11,12,15];
    
split = [0.5, 0.2, 0.2, 0.1];
classes = [1,2,3,4];

sensor_readings = [];

for i = 1:length(A.unit)
    
    selection = A.unit{i}(:,end) == operating_idx;
    sensor_buffer = A.unit{i}(selection, sensor_idx);
    
    [lin, col] = size(sensor_buffer);
    tamanho = lin;
    pos = floor(split.*tamanho);
    
    
    for n = 1:length(classes)
        class{n} = zeros(1,pos(n));
        class{n}(:) = n;
    end
    
    class_vec = [];
    class_vec = cell2mat(class)';
    
    qtde = length(class_vec);
    if length(class_vec) ~= tamanho
       diff_ = tamanho - length(class_vec);
       
       class_vec(qtde+1:qtde+diff_) = n;
    end
    
    sensor_buffer(:,end+1) = class_vec;
    
    sensor_readings = [sensor_readings; sensor_buffer];
        
end

[~, col] = size(sensor_readings);
sensor_readings = sortCol(sensor_readings, col);

filename = 'PHM08_OC_02_4Class_testSet__v000.csv'
mkdir Dataset
csvwrite(['./Dataset/' filename], sensor_readings)

















