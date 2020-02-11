clear; clc; close all;

fs = 96000;
frameLength = 960000;
nChannels = 6;
lag0 = 18.24; %the maximum lag between mic1 and mic3

%creat an audioDeviceReader object to record from sound card
deviceReader = audioDeviceReader(...
'Device', 'ReSpeaker 4 Mic Array (UAC1.0)  (ReSpeaker 4 Mic Array (UAC1.0))',...
'NumChannels', nChannels ,...
'SampleRate', fs);
setup(deviceReader);

%creat an audioFileWriter object to save the audio file
fileWriter = dsp.AudioFileWriter(...
    'mySpeech.wav',...
    'FileFormat','WAV',...
    'SampleRate', fs);

% creat a scope object to real-time dispaly audio wave
scope = dsp.TimeScope( ...                        
    'SampleRate',deviceReader.SampleRate, ...       
    'TimeSpan',10, ...                             
    'BufferLength',deviceReader.SampleRate*50, ... 
    'YLimits',[-1,1], ...                         
    'TimeSpanOverrunAction','Scroll');            

%
% ButtonHandle = uicontrol('Style', 'PushButton', ...
%                          'String', 'Stop loop', ...
%                          'Callback', 'delete(gcbf)');

%Display the estimate angle on a unit circle
alpha=0:pi/100:2*pi;
R=1;
x=R*cos(alpha); 
y=R*sin(alpha);
plot(x,y,'-')
axis square;
hold on
x0 = 0;
y0 = 1; 
p = plot(x0,y0,'r.','markersize',20);
p.XDataSource = 'x0';
p.YDataSource = 'y0';

%begain to record
disp('Speak into microphone now.');
tic;
while toc<100
    audio = record(deviceReader);
    step(fileWriter, audio);
    step(scope, audio);
    data_mic1 = audio(:,2);
    data_mic3 = audio(:,4);
    [lag, theta] = tdoa(data_mic1, data_mic3);
    x0 = R*cos(theta/180*pi);
    y0 = R*sin(theta/180*pi);
    refreshdata
    drawnow
%     if ~ishandle(ButtonHandle)
%         disp('Loop stopped by user');
%         break;
%     end
end
disp('Recording complete.');
release(deviceReader);
release(fileWriter);
release(scope);

% data = audioread('mySpeech.wav');
% data_mic1 = data(:,2);
% data_mic2 = data(:,3);
% data_mic3 = data(:,4);
% data_mic4 = data(:,5);
% 
% [lag, theta] = tdoa(data_mic1, data_mic3);
% displayangle(theta);
