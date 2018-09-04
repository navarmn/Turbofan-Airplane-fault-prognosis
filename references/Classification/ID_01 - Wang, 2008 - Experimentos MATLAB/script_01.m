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

Data = load("/media/navar/Dados/Mestrado/Mestrado/MP-Safety ITA/Conjuntos de dados/PHM08 - NASA/Conjunto de dados/train.txt");

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
    for j = 1:length(A.unit{i})
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

%% Scatter plot sensor readings from all units in each opearting regime.
% Section IV-A-2: Sensor selection
% "In the following procedures of this work, the seven sensors,
%  2, 3, 4, 7, 11, 12 and 15, are used"

sensor_idx = 11;           % 1 to 21
operating_idx = 1;         % 1 to 6

figure_preset();
hold on
sensor_readings = [];
for i = 1:length(A.unit)
    
    selection = A.unit{i}(:,end) == operating_idx;
    %sensor_readings = [sensor_readings; A.unit{i}(selection, 5 + sensor_idx)];
    plot(A.unit{i}(selection, 2), ...
         A.unit{i}(selection, 5 + sensor_idx), 'kx')
     
end

figure_postset('Cycle', 'Sensor reading');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sensor_idx = 8;           % 1 to 21
operating_idx = 6;         % 1 to 6

figure_preset();
hold on
sensor_readings = [];
for i = 1:length(A.unit)
    
    selection = A.unit{i}(:,end) == operating_idx;
    %sensor_readings = [sensor_readings; A.unit{i}(selection, 5 + sensor_idx)];
    plot(A.unit{i}(selection, 2), ...
         A.unit{i}(selection, 5 + sensor_idx), 'kx')
     
end

figure_postset('Cycle', 'Sensor reading');


%% Create a health indicator (HI).
% Section IV-A-4: Model identification
% "taking data from healthy and near-failure conditions of the system and 
% assigning the corresponding outputs with 1 and 0 respectively."

% "The selected seven sensors x = (x], X2, .•. , X7) are used to
% build six linear models in the form of (1), one for each
% operating regime."

operating_idx = 1:6;

for i = 1:length(A.unit)
    [lin, col] = size(A.unit{i});    
    for j = 1:length(operating_idx)
    
        selection = A.unit{i}(:,col) == operating_idx(j);
        y = linspace(1,0,length(A.unit{i}(selection,end)));
        A.unit{i}(selection,col+1) = y';
        
    end
end

% concatenate all units:
operating_idx = 1;
sensor_idx = [2,3,4,7,11,12,15];

sensor_readings = [];
HI_desired = [];
for i = 1:length(A.unit)
    
    selection = A.unit{i}(:,end-1) == operating_idx;
    sensor_readings = [sensor_readings; A.unit{i}(selection, sensor_idx)];
    HI_desired = [HI_desired; A.unit{i}(selection, end)];
     
end


%% Plot data from same unit and different sensors:

unit = 01;                    % 1 to 218
sensor = 01;                  % 1 to 21

figure_preset()

figure(1)
subplot(2,3,[1,2,4,5])
plotDataPHM(A, 'Unit', unit, 'AllSensors')
text = ['All sensor measeurements from Unit: ' num2str(unit) ...
        ' | All 21 Sensors'];
title(text)

figure(1)
subplot(2,3,3)

plotDataPHM(A, 'Unit', unit, 'Sensor', sensor,'NoParts')
text = ['All sensor measeurements from Unit: ' num2str(unit) ...
        ' | Sensor: ' num2str(sensor)];
title(text)

sensor = 15;

subplot(2,3,6)

plotDataPHM(A, 'Unit', unit, 'Sensor', sensor,'NoParts')
text = ['All sensor measeurements from Unit: ' num2str(unit) ...
        ' | Sensor: ' num2str(sensor)];
title(text)

%% Ploting same sensor from different units:

unit = 01;                    % 1 to 218
sensor = 15;                  % 1 to 21

figure(2)
subplot(2,1,1)

plotDataPHM(A, 'Unit', unit, 'Sensor', sensor,'NoParts')
text = ['All sensor measeurements from Unit: ' num2str(unit) ...
        ' | Sensor: ' num2str(sensor)];
title(text)


unit = 200;                     % 1 to 218

subplot(2,1,2)

plotDataPHM(A, 'Unit', unit, 'Sensor', sensor,'NoParts')
text = ['All sensor measeurements from Unit: ' num2str(unit) ...
        ' | Sensor: ' num2str(sensor)];
title(text)











