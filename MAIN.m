clearvars,delete(get(0,'children')),clc
% MAIN FUNCTION FOR YEAST CELL AND LIPID DROPLETS DETECTION
% In the Command window is written list of used scripts, functions and
% toolboxes needed for this program to work...

% User can define which cells to process by menu:
% POMBE / CERE / JAPONICUS

[fList,pList] = matlab.codetools.requiredFilesAndProducts('MAIN.m');
for i=1:length(pList)
    disp(['Toolboxes used in the processing: ' pList(i).Name])
end
for i=1:length(fList)
    myFun = split(fList{1,i},"\");
    disp(['My functions: ' myFun(end)])
end

% Profile to observe performance of the algorithm
profile on

% OUTPUT directories
dmh=datestr(now,'_dd_mm-hh');
out=['OUT_' dmh '_FINAL'];
mkdir(out)
mkdir([out '\JAP'])
mkdir([out '\POM'])
mkdir([out '\CER'])
mkdir([out '\CSV'])


k = menu('What do you want to process:','Cere','Pombe','Japonicus','Exit');
% for k = 1:3
switch k
    case 1
        disp('Cere')
        Z = 14;
        [B_Files,G_Files] = fcn_FileCheck('cere');
        N_B = size(B_Files,1);
        N_G = size(G_Files,1);
        formatSpec = 'Z-stack:     %d\nBlue files:  %d\nGreen files: %d \n';
        fprintf(formatSpec,Z,N_B,N_G)
        
        [outputT,outputB] = fcn_CERE(B_Files,N_B,G_Files,N_G,Z,out);
    case 2
        disp('Pombe')
        Z = 18;
        [B_Files,G_Files] = fcn_FileCheck('pombe');
        N_B = size(B_Files,1);
        N_G = size(G_Files,1);
        formatSpec = 'Z-stack:     %d\nBlue files:  %d\nGreen files: %d \n';
        fprintf(formatSpec,Z,N_B,N_G)
        
        [outputT,outputB] = fcn_POMBE2(B_Files,N_B,G_Files,N_G,Z,out);
    case 3
        disp('Japonicus')
        Z = 23;
        [B_Files,G_Files] = fcn_FileCheck('japonicus');
        N_B = size(B_Files,1);
        N_G = size(G_Files,1);
        formatSpec = 'Z-stack:     %d\nBlue files:  %d\nGreen files: %d \n';
        fprintf(formatSpec,Z,N_B,N_G)
        
        [outputT,outputB] = fcn_JAP(B_Files,N_B,G_Files,N_G,Z,out);
    otherwise
        disp('Nothing selected...')
end
% end