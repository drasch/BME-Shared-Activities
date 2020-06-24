function BME303L_EscapeRoom(action)

%% Define Global Variables
    % These variables are used across multiple function calls
        global htimer
        global RoomImage
        global ax
        global ax2
        global T1
        global TIME
        global Num1
        global Num2
        global Num3
        global NumHints
        global NumWrongAnswers
        
%% Define GUI Window Labels
    gui_tag = 'BME303L_EscapeRoom';
    gui_fname = 'BME303L_EscapeRoom';
    gui_version = 'Spring 2019';

% Action for calling function in command window
    if nargin<1
        action = 'Initialize';
    end

%% Run GUI
switch action

%% Case = Initialize
% This section of code initializes the GUI window, including all of the
% buttons, text, drop-down menus, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'Initialize'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Defines GUI appearance and button functions
    fontname = 'Arial';
    fontweight = 'bold';
    fontsize = 20;
    a = get(0,'ScreenSize');

    % GUI Window Definition
    Hgui = figure('Name',sprintf('BME303L Escape Room (%s)',gui_version), ...
                  'NumberTitle','off',...
                  'ToolBar','none',...
                  'Tag', gui_tag,...
                  'MenuBar','none', ...
                  'Color', 'white', ...
                  'Position', [a(1) a(2) a(3) a(4)], ...
                  'CloseRequestFcn',@closeRequestFcn);
                
   % Menu Bar Information in GUI Window
    filemenu = uimenu('Label','File');
    uimenu(filemenu,'Label','Exit','Callback',@closeRequestFcn);
    helpmenu = uimenu('Label','Help');
    uimenu(helpmenu,'Label','Game Rules','Callback',@gameRulesFcn);
    uimenu(helpmenu,'Label','About','Separator','on','Callback',@aboutFcn);
                
   % Room Image (primary axis for room-specific puzzle images)
    RoomImage = uipanel('BackgroundColor', 'White', ...
                        'Position',[0.01 0.01 0.69 0.98], ...
                        'Tag', 'RoomImage');
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    IM = imread('EscapeRoom.png'); % Default start-up image with game rules
    image(IM);
    axis image
    axis off
    
   % Room Name (drop-down menu that lets the user select a specific room)
    pos = [0.705 0.9 0.14 0.075];
    HRoomName = uicontrol('Style','popupmenu', ...
                          'BackGroundColor', 'White', ...
                          'ForegroundColor', 'Black', ...
                          'Enable','Off', ...
                          'Callback',[gui_fname,'(''RoomName'')'], ...
                          'FontName', fontname, ...
                          'FontSize', 18, ...
                          'FontWeight', fontweight, ...
                          'Units', 'normalized', ...
                          'Position',pos,...  
                          'Tag','RoomName', ...
                          'String', {'ROOM NAME', '1. Signals & Systems', ...
                                     '2. X-Ray', '3. CT', '4. Ultrasound', ...
                                     '5. MRI', '6. Nuclear Medicine'}); 

    % Secret Code (text that says 'Secret Code')
    pos = [0.705 0.88 0.14 0.04];
    HSecretCode = uicontrol('Style','text', ...
                            'BackGroundColor', 'green', ...
                            'FontName', fontname, ...
                            'FontSize', fontsize, ...
                            'FontWeight', fontweight, ...
                            'Units', 'normalized', ...
                            'Position',pos,...  
                            'String', 'Secret Code', ...
                            'Tag','SecretCode'); 
    
    % Timer (push button that allows user to start the game)
    pos = [0.85 0.93 0.14 0.05];
    HTimer = uicontrol('Style','pushbutton', ...
                       'Enable', 'On', ...
                       'Callback',[gui_fname,'(''Timer'')'], ...
                       'BackGroundColor', 'yellow', ...
                       'FontName', fontname, ...
                       'FontSize', fontsize, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'String', 'Press to Start', ...
                       'Tag','Timer');    
    
    % Code Value 1 (drop-down menu to select first code value)
    pos = [0.705 0.78 0.085 0.1];
    HCode1 = uicontrol('Style','popupmenu', ...
                       'BackGroundColor', 'white', ...
                       'ForegroundColor', 'black', ...
                       'Callback',[gui_fname,'(''CodeValue1'')'], ...
                       'Enable','Off', ...
                       'FontName', fontname, ...
                       'FontSize', fontsize, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'Tag','CodeValue1', ...
                       'String', {'#', '0', '1', '2', '3', '4', '5', '6', ...
                                  '7', '8', '9'});
    
    % Code Value 2 (drop-down menu to select second code value)
    pos = [0.705 0.74 0.085 0.1];
    HCode2 = uicontrol('Style','popupmenu', ...
                       'BackGroundColor', 'white', ...
                       'ForegroundColor', 'black', ...
                       'Callback',[gui_fname,'(''CodeValue2'')'], ...
                       'Enable','Off', ...
                       'FontName', fontname, ...
                       'FontSize', fontsize, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'Tag','CodeValue2', ...
                       'String', {'#', '0', '1', '2', '3', '4', '5', '6', ...
                                  '7', '8', '9'});
    
    % Code Value 3  (drop-down menu to select third code value)
    pos = [0.705 0.7 0.085 0.1];
    HCode3 = uicontrol('Style','popupmenu', ...
                       'BackGroundColor', 'white', ...
                       'ForegroundColor', 'black', ...
                       'Callback',[gui_fname,'(''CodeValue3'')'], ...
                       'Enable','Off', ...
                       'FontName', fontname, ...
                       'FontSize', fontsize, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'Tag','CodeValue3', ...
                       'String', {'#', '0', '1', '2', '3', '4', '5', '6', ...
                                  '7', '8', '9'});
                              
    % Enter Secret Code (push button that allows user to enter secret code)
    pos = [0.788 0.795 0.055 0.05];
    HEnter = uicontrol('Style','pushbutton', ...
                       'Enable', 'Off', ...
                       'Callback',[gui_fname,'(''Enter'')'], ...
                       'BackGroundColor', 'red', ...
                       'ForegroundColor', 'white', ...
                       'FontName', fontname, ...
                       'FontSize', fontsize-2, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'String', 'ENTER', ...
                       'Tag','Enter'); 
    NumWrongAnswers = 0; % variable to track how many wrong answers were inputted
    
    % Help (text that says 'Help')
    pos = [0.85 0.88 0.14 0.04];
    HHelp = uicontrol('Style','text', ...
                      'BackGroundColor', 'blue', ...
                      'ForegroundColor', 'white', ...
                      'FontName', fontname, ...
                      'FontSize', fontsize, ...
                      'FontWeight', fontweight, ...
                      'Units', 'normalized', ...
                      'Position',pos,...  
                      'String', 'Help', ...
                      'Tag','Help');
    
    % Hint 1 (push button that allows user to receive first hint)
    pos = [0.85 0.84 0.14 0.04];
    HHint1 = uicontrol('Style','pushbutton', ...
                       'BackGroundColor', 'white', ...
                       'FontName', fontname, ...
                       'Enable', 'Off',...
                       'Callback',[gui_fname,'(''Hint1'')'], ...
                       'FontSize', fontsize, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'String', 'Hint 1', ...
                       'Tag','Hint1');
         
    NumHints = 0; % variable to track how many hints were used in the game
    
    % Hint 2 (push button that allows user to receive second hint)
    pos = [0.85 0.80 0.14 0.04];
    HHint2 = uicontrol('Style','pushbutton', ...
                       'BackGroundColor', 'white', ...
                       'FontName', fontname, ...
                       'Enable', 'Off',...
                       'Callback',[gui_fname,'(''Hint2'')'], ...
                       'FontSize', fontsize, ...
                       'FontWeight', fontweight, ...
                       'Units', 'normalized', ...
                       'Position',pos,...  
                       'String', 'Hint 2', ...
                       'Tag','Hint2');

    % Solution (push button that allows user to receive room solution)
    pos = [0.85 0.76 0.14 0.04];
    HSolution = uicontrol('Style','pushbutton', ...
                          'BackGroundColor', 'white', ...
                          'FontName', fontname, ...
                          'Enable', 'Off',...
                          'Callback',[gui_fname,'(''Solution'')'], ...
                          'FontSize', fontsize, ...
                          'FontWeight', fontweight, ...
                          'Units', 'normalized', ...
                          'Position',pos,...  
                          'String', 'Solution', ...
                          'Tag','Solution');
    
    % Card Information (secondary axis for room-specific puzzles/hints)
    p3 = uipanel('BackgroundColor', 'White', ...
                 'Position',[0.705 0.085 0.285 0.67], ...
                 'Tag', 'CardInformation');
    ax2 = axes(p3, 'Units', 'normalized', 'Position', [0 0 1 1]);
    IM = imread('EscapeRoomCard.png');
    image(IM);
    axis image
    axis off
    
    % Room 1 Solved (button to show whether or not Room 1 has been solved)
    pos = [0.705 0.01 0.02 0.04];
    HRoom1Solved = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''Room1Solved'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '1', ...
                             'Tag','Room1Solved');

    % Room 2 Solved (button to show whether or not Room 2 has been solved)
    pos = [0.728 0.01 0.02 0.04];
    HRoom2Solved = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''Room2Solved'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '2', ...
                             'Tag','Room2Solved');
                         
    % Room 3 Solved (button to show whether or not Room 3 has been solved)
    pos = [0.751 0.01 0.02 0.04];
    HRoom3Solved = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''Room3Solved'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '3', ...
                             'Tag','Room3Solved');
                         
    % Room 4 Solved (button to show whether or not Room 4 has been solved)
    pos = [0.774 0.01 0.02 0.04];
    HRoom4Solved = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''Room4Solved'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '4', ...
                             'Tag','Room4Solved');
                         
    % Room 5 Solved (button to show whether or not Room 5 has been solved)
    pos = [0.797 0.01 0.02 0.04];
    HRoom5Solved = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''Room5Solved'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '5', ...
                             'Tag','Room5Solved');
                         
    % Room 6 Solved (button to show whether or not Room 6 has been solved)
    pos = [0.820 0.01 0.02 0.04];
    HRoom6Solved = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''Room6Solved'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '6', ...
                             'Tag','Room6Solved');
                         
    % Rooms Solved (text that says 'Rooms Solved')
    pos = [0.705 0.06 0.135 0.026];
    HRoomsSolved = uicontrol('Style','text', ...
                             'BackGroundColor', 'white', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'FontSize', 16, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', 'Rooms Solved', ...
                             'Tag','RoomsSolved');

    % Penalty Time Text (text that says 'Penalty')
    pos = [0.843 0.06 0.06 0.026];
    HPenaltyText = uicontrol('Style','text', ...
                             'BackGroundColor', 'white', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'FontSize', 16, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', 'Penalty', ...
                             'Tag','PenaltyTimeText');
                         
    % Penalty Time (text that shows total amount of penalty time accumulated)
    pos = [0.843 0.01 0.06 0.04];
    HPenaltyTime = uicontrol('Style','text', ...
                             'BackGroundColor', 'red', ...
                             'FontName', fontname, ...
                             'Enable', 'On',...
                             'Callback',[gui_fname,'(''PenaltyTime'')'], ...
                             'FontSize', fontsize, ...
                             'FontWeight', fontweight, ...
                             'Units', 'normalized', ...
                             'Position',pos,...  
                             'String', '0:00', ...
                             'Tag','PenaltyTime');
                         
    % Total Time Text (text that says 'Total Time')
    pos = [0.906 0.06 0.085 0.026];
    HTotalTimeText = uicontrol('Style','text', ...
                               'BackGroundColor', 'white', ...
                               'FontName', fontname, ...
                               'Enable', 'On',...
                               'FontSize', 16, ...
                               'FontWeight', fontweight, ...
                               'Units', 'normalized', ...
                               'Position',pos,...  
                               'String', 'Total Time', ...
                               'Tag','TotalTimeText');
                         
    % Total Time (text that shows total amount of time needed to escape
    % (including penalties))
    pos = [0.906 0.01 0.085 0.04];
    HTotalTime = uicontrol('Style','text', ...
                           'BackGroundColor', 'green', ...
                           'FontName', fontname, ...
                           'Enable', 'On',...
                           'Callback',[gui_fname,'(''TotalTime'')'], ...
                           'FontSize', fontsize, ...
                           'FontWeight', fontweight, ...
                           'Units', 'normalized', ...
                           'Position',pos,...  
                           'String', '0:00', ...
                           'Tag','TotalTime');

%% Case = RoomName
% This section of code is activated when the user selects a room. It loads 
% the puzzle corresponding to the selected room, activates the room code
% drop-down menus, and activates the hint 1 button.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'RoomName'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HTimer      = findobj('Tag','Timer');
HCode1      = findobj('Tag','CodeValue1');
HCode2      = findobj('Tag','CodeValue2');
HCode3      = findobj('Tag','CodeValue3');
HHint1      = findobj('Tag','Hint1');
HHint2      = findobj('Tag', 'Hint2');
HSolution   = findobj('Tag','Solution');
HEnter   = findobj('Tag','Enter');

Room = get(HRoomName, 'Value');
set(HCode1, 'Enable', 'On')
set(HCode2, 'Enable', 'On')
set(HCode3, 'Enable', 'On')
set(HEnter, 'Enable', 'On')
set(HCode1, 'Value', 1)
set(HCode2, 'Value', 1)
set(HCode3, 'Value', 1)

if Room == 2 % Signals & Systems Room
    % Sets all 3 room code drop-down menus to display A-OO
    set(HCode1, 'String', {'abc', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', ...
                           'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', ...
                           'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ...
                           'AA', 'BB', 'CC', 'DD', 'EE', 'FF', 'GG', 'HH', ...
                           'II', 'JJ', 'KK', 'LL', 'MM', 'NN', 'OO'});
    set(HCode2, 'String', {'abc', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', ...
                           'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', ...
                           'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ...
                           'AA', 'BB', 'CC', 'DD', 'EE', 'FF', 'GG', 'HH', ...
                           'II', 'JJ', 'KK', 'LL', 'MM', 'NN', 'OO'});
    set(HCode3, 'String', {'abc', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', ...
                           'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', ...
                           'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', ...
                           'AA', 'BB', 'CC', 'DD', 'EE', 'FF', 'GG', 'HH', ...
                           'II', 'JJ', 'KK', 'LL', 'MM', 'NN', 'OO'});
    % Generates 10 different k-space matrices based on delta functions
    % located at various positions
    [KSpace1,IM1]   = imagedomain(4,  4);  % A
    [KSpace2,IM2]   = imagedomain(-2, 2);  % Y
    [KSpace3,IM3]   = imagedomain(0,  4);  % KK
    [KSpace4,IM4]   = imagedomain(-4, 4);  % I
    [KSpace5,IM5]   = imagedomain(2,  2);  % U
    [KSpace6,IM6]   = imagedomain(0,  2);  % MM
    [KSpace7,IM7]   = imagedomain(1,  1);  % EE
    [KSpace8,IM8]   = imagedomain(-1, 1);  % GG
    [KSpace9,IM9]   = imagedomain(-3, 3);  % Q
    [KSpace10,IM10] = imagedomain(3,  3);  % K
    
    % Generates 4 different k-space examples with specific spacing between
    % delta functions. These are our "Spacing Examples 1-4."
    [KSpace11,IM11] = imagedomain(1,0);
    [KSpace12,IM12] = imagedomain(2,0);
    [KSpace13,IM13] = imagedomain(3,0);
    [KSpace14,IM14] = imagedomain(4,0);
    
    % Answers = the letter corresponding to the proper delta functions in
    % the image domain
    % AnswersNums = the corresponding number that the drop-down menu
    % associates each letter with
    Answers =     {'A', 'Y', 'KK', 'I', 'U', 'MM', 'EE', 'GG', 'Q', 'K'};
    AnswersNums = [ 0    24   36    8    20   38    30    32    16   10];
    
    % Random number generator to select 3 distinct values for the secret code
    RandomNumMRI = randperm(10,3);
    
    Num1 = AnswersNums(1, RandomNumMRI(1)); % Secret code value 1
    Num2 = AnswersNums(1, RandomNumMRI(2)); % Secret code value 2
    Num3 = AnswersNums(1, RandomNumMRI(3)); % Secret code value 3
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax allows each subplot to span multiple subplot
    % locations. This just makes everything look neater, and it wastes less
    % screen space. 
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(9,20,[1:5 21:25 41:45 61:65 81:85])
    imshow(imread(strcat(pwd, '/SignalsSystems/ImageDomain.jpg')));
    axis equal
    
    KSPACE1 = eval(strcat('KSpace', num2str(RandomNumMRI(1))));
    subplot(9,20,[6:10 26:30 46:50 66:70 86:90])
    imshow(abs(KSPACE1./max(KSPACE1(:))));
    axis equal
    
    KSPACE2 = eval(strcat('KSpace', num2str(RandomNumMRI(2))));
    subplot(9,20,[11:15 31:35 51:55 71:75 91:95])
    imshow(abs(KSPACE2./max(KSPACE2(:))));
    axis equal
    
    KSPACE3 = eval(strcat('KSpace', num2str(RandomNumMRI(3))));
    subplot(9,20,[16:20 36:40 56:60 76:80 96:100])
    imshow(abs(KSPACE3./max(KSPACE3(:))));
    axis equal
    
    subplot(9,20,[101:105 121:125 141:145 161:165])
    imshow(abs(KSpace11./max(KSpace11(:))));
    axis equal
    title('Spacing Example 1');
    
    subplot(9,20,[106:110 126:130 146:150 166:170])
    imshow(abs(KSpace12./max(KSpace12(:))));
    axis equal
    title('Spacing Example 2');
    
    subplot(9,20,[111:115 131:135 151:155 171:175])
    imshow(abs(KSpace13./max(KSpace13(:))));
    axis equal
    title('Spacing Example 3');
    
    subplot(9,20,[116:120 136:140 156:160 176:180])
    imshow(abs(KSpace14./max(KSpace14(:))));
    axis equal
    title('Spacing Example 4');
    
    % Displays blank escape room card on secondary axis (ax2) of GUI
    IM = imread(strcat(pwd, '/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    
end

if Room == 3 % XRay Room
    % Sets all 3 room code drop-down menus to display 0-25
    set(HCode1, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11', '12', '13', '14', '15', ...
                           '16', '17', '18', '19', '20', '21', '22', '23', ...
                           '24', '25'});
    set(HCode2, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11', '12', '13', '14', '15', ...
                           '16', '17', '18', '19', '20', '21', '22', '23', ...
                           '24', '25'});
    set(HCode3, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11', '12', '13', '14', '15', ...
                           '16', '17', '18', '19', '20', '21', '22', '23', ...
                           '24', '25'});
                       
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    
    WidthS1=floor(rand(1)*3)+1; % Original source width
    WidthO1=floor(rand(1)*8)+8; % Original object width

    M=round(rand(1)*5)+2; % Magnetization factor, M
    m=M-1; % Magnetization factor, m
    
    WidthS=WidthS1*m; % Magnified source width
    WidthO=WidthO1*M; % Magnified object width
    
    dx=.01; % Sample width
    x=[-WidthO/2-1:dx:WidthO/2+1]; % x values for magnified object
    x2=[-WidthS/2-1:dx:WidthS/2+1]; % x values for magnified source

    ind=find(abs(x2)<WidthS/2); % Finds indices to create magnified rect source function
    ind2=find(abs(x)<WidthO/2); % Finds indices to create magnified rect object function

    S=zeros(size(x2)); % Initializes magnified source function
    O=zeros(size(x)); % Initializes magnified object function
    S(ind)=1; % Creates magnified rect source function
    O(ind2)=1; % Creates magnified rect object function

    xs=[-WidthS1/2-1:dx:WidthS1/2+1]; % x values for original source
    xo=[-WidthO1/2-1:dx:WidthO1/2+1]; % x values for original object
    ind2=find(abs(xs)<WidthS1/2); % Finds indices to create original rect source function
    ind3=find(abs(xo)<WidthO1/2); % Finds indices to create original rect object function

    Source=zeros(size(xs)); % Initializes original source function
    Object=zeros(size(xo)); % Initializes original object function
    Source(ind2)=1; % Creates original rect source function
    Object(ind3)=1; % Creates original rect object function

    Result=conv(S,O); % Convolves the magnified source and object functions to yield the detected image
    xRes=[x(1)+x2(1):dx:x(end)+x2(end)]; % x values for detected image

    horzlinex = linspace(min(xRes)-25, max(xRes) + 25, 100); % x values for horizontal axes on plot

    Plateau = WidthO - WidthS; % Plateau width
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other. 
    axes(ax);
    cla
    subplot(1,1,1);
    % Plots original source function
    plot(xs, Source./max(Source) + 10, 'k-', 'LineWidth', 2)
    hold on
    % Adds a red fill to the original source function
    x2 = [xs, fliplr(xs)];
    inBetween = [Source./max(Source) + 10, fliplr(10.*ones(1,length(xs)))];
    fill(x2, inBetween, 'r');
    % Plots a horizontal line beneath the original source function
    plot(horzlinex, zeros(1,100)+10, 'k-', 'LineWidth', 2);
    % Displays text that specifies the original source width
    text(max(xRes),10.5,sprintf('Source Width = %.1d', WidthS1), ...
         'FontSize', 12, 'FontWeight', 'Bold')

    % Plots original object function
    plot(xo, Object./max(Object) + 5, 'k-', 'LineWidth', 2)
    % Plots a horizontal line beneath the original object function
    plot(horzlinex, zeros(1,100)+5, 'k-', 'LineWidth', 2);
    % Displays text that specifies the original object width
    text(max(xRes),5.5,sprintf('Object Width = %.1d', WidthO1), ...
         'FontSize', 12, 'FontWeight', 'Bold')
    % Adds a blue fill to the original object function
    x3 = [xo, fliplr(xo)];
    inBetween2 = [Object./max(Object) + 5, fliplr(5.*ones(1,length(xo)))];
    fill(x3, inBetween2, 'b');

    % Plots output image
    plot(xRes, Result./max(Result), 'k-', 'LineWidth', 2)
    % Plots a horizontal line beneath the output image
    plot(horzlinex, zeros(1,100), 'k-', 'LineWidth', 2);
    % Displays text that specifies the plateu width of the output image
    text(max(xRes),0.5,sprintf('Plateau Width = %.1d', Plateau), ...
         'FontSize', 12, 'FontWeight', 'Bold')
    % Plots a horizontal line beneath the output image
    plot(linspace(Plateau/2, Plateau/2+WidthS, 100), zeros(1,100)-0.15, 'k-');
    % Displays text that defines the penumbra width of the output image
    text(mean([Plateau/2 Plateau/2+WidthS]),-0.3,'x', ...
         'FontSize', 12, 'FontWeight', 'Bold')
    % Adds a green fill to the output image
    x4 = [xRes, fliplr(xRes)];
    inBetween3 = [Result./max(Result), fliplr(zeros(1,length(xRes)))];
    fill(x4, inBetween3, 'g');
    hold off

    % Sets the x limits on the plot
    xlim([min(xRes)-25 max(xRes)+25]);
    
    % Turns off the axis so that the students can't approximate sizes
    % visually as easily
    axis off

    x = WidthS; % Penumbra width = magnified source width
    OUTPUTxray = [M; m; x]; % Format of secret code values
    Num1 = OUTPUTxray(1); % Secret code value 1
    Num2 = OUTPUTxray(2); % Secret code value 2
    Num3 = OUTPUTxray(3); % Secret code value 3
    
    % Displays X-ray escape room card on secondary axis (ax2) of GUI (says
    % M = ?, m = ?, x = ?)
    IM = imread(strcat(pwd, '/XRay/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end

if Room == 4 % CT Room
    % Sets all 3 room code drop-down menus to display 0-9
    set(HCode1, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9'});
    set(HCode2, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9'});
    set(HCode3, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9'});
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    
    % Loads data contained in Dice.mat file
    filename = strcat(pwd, '/CT/Dice.mat');
    Data = load(filename);
    
    % Random number generator to select 3 distinct values for the secret code
    RandomNums = randperm(6,3);

    Num1 = RandomNums(1); % Secret code value 1
    Num2 = RandomNums(2); % Secret code value 2
    Num3 = RandomNums(3); % Secret code value 3

    % Decides which sinogram should be displayed based on secret code value 1
    if Num1 == 1
        %Im1 = Data.ImageOne;
        Sino1 = Data.SinoOne;
    elseif Num1 == 2
        %Im1 = Data.ImageTwo;
        Sino1 = Data.SinoTwo;
    elseif Num1 == 3
        %Im1 = Data.ImageThree;
        Sino1 = Data.SinoThree;
    elseif Num1 == 4
        %Im1 = Data.ImageFour;
        Sino1 = Data.SinoFour;
    elseif Num1 == 5
        %Im1 = Data.ImageFive;
        Sino1 = Data.SinoFive;    
    elseif Num1 == 6
        %Im1 = Data.ImageSix;
        Sino1 = Data.SinoSix;  
    end
    
    % Decides which sinogram should be displayed based on secret code value 2
    if Num2 == 1
        %Im2 = Data.ImageOne;
        Sino2 = Data.SinoOne;
    elseif Num2 == 2
        %Im2 = Data.ImageTwo;
        Sino2 = Data.SinoTwo;
    elseif Num2 == 3
        %Im2 = Data.ImageThree;
        Sino2 = Data.SinoThree;
    elseif Num2 == 4
        %Im2 = Data.ImageFour;
        Sino2 = Data.SinoFour;
    elseif Num2 == 5
        %Im2 = Data.ImageFive;
        Sino2 = Data.SinoFive;    
    elseif Num2 == 6
        %Im2 = Data.ImageSix;
        Sino2 = Data.SinoSix;
    end

    % Decides which sinogram should be displayed based on secret code value 3
    if Num3 == 1
        %Im3 = Data.ImageOne;
        Sino3 = Data.SinoOne;
    elseif Num3 == 2
        %Im3 = Data.ImageTwo;
        Sino3 = Data.SinoTwo;
    elseif Num3 == 3
        %Im3 = Data.ImageThree;
        Sino3 = Data.SinoThree;
    elseif Num3 == 4
        %Im3 = Data.ImageFour;
        Sino3 = Data.SinoFour;
    elseif Num3 == 5
        %Im3 = Data.ImageFive;
        Sino3 = Data.SinoFive;    
    elseif Num3 == 6
        %Im3 = Data.ImageSix;
        Sino3 = Data.SinoSix; 
    end
    
    % Displays puzzle on primary axis (ax) of GUI
    axes(ax);
    cla
    subplot 131
    imshow(Sino1'./max(Sino1(:)));
    axis equal

    subplot 132
    imshow(Sino2'./max(Sino2(:)));
    axis equal

    subplot 133
    imshow(Sino3'./max(Sino3(:)));
    axis equal 
    
    % Displays blank escape room card on secondary axis (ax2) of GUI
    IM = imread(strcat(pwd, '/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    
end

if Room == 5 % Ultrasound
    % Sets all 3 room code drop-down menus to display 0-9
    set(HCode1, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9'});
    set(HCode2, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9'});
    set(HCode3, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9'});
                       
    % Random number generator to select 3 distinct values for the secret code
    RandomNumMRI = randperm(9,3);
    
    Num1 = RandomNumMRI(1,1); % Secret code value 1
    Num2 = RandomNumMRI(1,2); % Secret code value 2
    Num3 = RandomNumMRI(1,3); % Secret code value 3
    
    % Filenames of all of the ultrasound images of the different foods
    files = {'US_Banana.jpeg','US_Egg.jpeg','US_Lemon.jpeg','US_Pickles.jpeg', ...
             'US_Potato.jpeg','US_Raspberry.jpeg', 'US_RedOnion.jpeg',...
             'US_Strawberry.jpeg','US_Tomato.jpeg'};
         
    % Filenames of all of the stock images of the different foods
    files_options = {'Banana.jpg', 'Egg.png', 'Lemon.jpeg', 'Pickles.jpeg', ...
                     'Potatoes.jpg', 'Raspberry.jpg', 'RedOnion.jpg', ...
                     'Strawberry.jpg', 'Tomatoes.jpg'};
                 
    % Loads the three mystery ultrasound images based on the secret code             
    IM1 = imread(strcat(pwd, '/Ultrasound/', files{1,Num1}));
    IM2 = imread(strcat(pwd, '/Ultrasound/', files{1,Num2}));
    IM3 = imread(strcat(pwd, '/Ultrasound/', files{1,Num3}));
    
    % Loads the stock images of the different foods
    option1 = imread(strcat(pwd, '/Ultrasound/', files_options{1,1}));
    option2 = imread(strcat(pwd, '/Ultrasound/', files_options{1,2}));
    option3 = imread(strcat(pwd, '/Ultrasound/', files_options{1,3}));
    option4 = imread(strcat(pwd, '/Ultrasound/', files_options{1,4}));
    option5 = imread(strcat(pwd, '/Ultrasound/', files_options{1,5}));
    option6 = imread(strcat(pwd, '/Ultrasound/', files_options{1,6}));
    option7 = imread(strcat(pwd, '/Ultrasound/', files_options{1,7}));
    option8 = imread(strcat(pwd, '/Ultrasound/', files_options{1,8}));
    option9 = imread(strcat(pwd, '/Ultrasound/', files_options{1,9}));
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax allows each subplot to span multiple subplot
    % locations. This just makes everything look neater, and it wastes less
    % screen space.
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax); 
    cla
    subplot(4,12,[1:4 13:16])
    imshow(IM1);
    axis equal
    
    subplot(4,12,[5:8 17:20])
    imshow(IM2);
    axis equal
    
    subplot(4,12,[9:12 21:24])
    imshow(IM3);
    axis equal
    
    subplot(4,12,[26 27])
    imshow(option1);
    axis equal
    title('1. Banana');
    
    subplot(4,12,[28 29])
    imshow(option2);
    axis equal
    title('2. Egg');
    
    subplot(4,12,[30 31])
    imshow(option3);
    axis equal
    title('3. Lemon');
    
    subplot(4,12,[32 33])
    imshow(option4);
    axis equal
    title('4. Pickle');
    
    subplot(4,12,[34 35])
    imshow(option5);
    axis equal
    title('5. Potato');
    
    subplot(4,12,[39 40])
    imshow(option6);
    axis equal
    title('6. Raspberry');
    
    subplot(4,12,[41 42])
    imshow(option7);
    axis equal
    title('7. Red Onion');
    
    subplot(4,12,[43 44])
    imshow(option8);
    axis equal
    title('8. Strawberry');
    
    subplot(4,12,[45 46])
    imshow(option9);
    axis equal
    title('9. Tomato');

    % Displays blank escape room card on secondary axis (ax2) of GUI
    IM = imread(strcat(pwd, '/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end

if Room == 6 % MRI
    % Sets all 3 room code drop-down menus to display 0-25
    set(HCode1, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11', '12', '13', '14', '15', ...
                           '16', '17', '18', '19', '20', '21', '22', '23', ...
                           '24', '25'});
    set(HCode2, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11', '12', '13', '14', '15', ...
                           '16', '17', '18', '19', '20', '21', '22', '23', ...
                           '24', '25'});
    set(HCode3, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11', '12', '13', '14', '15', ...
                           '16', '17', '18', '19', '20', '21', '22', '23', ...
                           '24', '25'});
                       
    % Random number generator to select 3 distinct values for the secret code
    RandomNumMRI = randperm(15,3);
    
    Num1 = RandomNumMRI(1,1); % Secret code value 1
    Num2 = RandomNumMRI(1,2); % Secret code value 2
    Num3 = RandomNumMRI(1,3); % Secret code value 3
    
    % Filenames of all of the possible MRI pulse sequence diagrams
    files = {'MRI_GRE_TE3.png','MRI_GRE_TE8.png','MRI_GRE_TE13.png', ...
             'MRI_GRE_TE18.png','MRI_GRE_TE23.png','MRI_GREy_TE11.png',...
             'MRI_GREy_TE12.png','MRI_GREy_TE13.png','MRI_GREy_TE14.png',...
             'MRI_GREy_TE15.png','MRI_Spiral1_TE13.png','MRI_Spiral2_TE13.png',...
             'MRI_Spiral3_TE13.png','MRI_Spiral4_TE13.png','MRI_Spiral5_TE13.png'};
         
    % Picks the proper file based on secret code value 1
    filename = strcat(pwd, '/MRI/', files{1,Num1});
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other. 
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax); 
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
    
    % Displays blank escape room card on secondary axis (ax2) of GUI
    IM = imread(strcat(pwd, '/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end

if Room == 7 %% Nuclear Medicine
    % Sets all 3 room code drop-down menus to display 0-11
    set(HCode1, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11'});
    set(HCode2, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11'});
    set(HCode3, 'String', {'#', '0', '1', '2', '3', '4', '5', '6', '7', ...
                           '8', '9', '10', '11'});
                       
    % Random number generator to select 3 distinct values for the secret code
    RandomNumNM = randperm(8,3);
    
    Num1 = RandomNumNM(1,1); % Secret code value 1
    Num2 = RandomNumNM(1,2); % Secret code value 2
    Num3 = RandomNumNM(1,3); % Secret code value 3
    
    % Filenames of all of the possible PET Roman Numeral diagrams
    files = {'PET_I2.png','PET_II2.png','PET_III2.png','PET_IV2.png',...
             'PET_V2.png','PET_VI2.png','PET_IX2.png','PET_X2.png',};
         
    % Picks the proper file based on secret code value 1
    filename = strcat(pwd, '/NuclearMedicine/', files{1,Num1});
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other. 
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
    
    % Displays blank escape room card on secondary axis (ax2) of GUI
    IM = imread(strcat(pwd, '/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end
    
% Enables user to input room codes
set(HCode1, 'Enable', 'On'); 
set(HCode2, 'Enable', 'On');
set(HCode3, 'Enable', 'On');

% Disables secret code values 2 & 3 so users know to only input one value
% at a time
if Room == 6 || Room == 7
    set(HCode1, 'Enable', 'On'); 
    set(HCode2, 'Enable', 'Off');
    set(HCode3, 'Enable', 'Off');
end
    

set(HRoomName, 'UserData', Room); % Saves the room number to be used in other functions
set(HHint1, 'Enable', 'On'); % Enables user to click on the Hint 1 button
set(HHint2, 'Enable', 'Off'); % Disables the Hint 2 button
set(HSolution, 'Enable', 'Off'); % Diables the Solution button

%% Case = CodeValue1
% This section of code allows the user to input the first secret code
% value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'CodeValue1'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HCode1      = findobj('Tag','CodeValue1');
HCode2      = findobj('Tag','CodeValue2');
HCode3      = findobj('Tag','CodeValue3');

Code1 = get(HCode1, 'Value');

set(HCode1, 'UserData', Code1)

%% Case = CodeValue2
% This section of code allows the user to input the second secret code
% value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'CodeValue2'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HCode1      = findobj('Tag','CodeValue1');
HCode2      = findobj('Tag','CodeValue2');
HCode3      = findobj('Tag','CodeValue3');

Code2 = get(HCode2, 'Value');

set(HCode2, 'UserData', Code2)


%% Case = CodeValue3
% This section of code allows the user to input the third secret code
% value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'CodeValue3'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HCode1      = findobj('Tag','CodeValue1');
HCode2      = findobj('Tag','CodeValue2');
HCode3      = findobj('Tag','CodeValue3');

Code3 = get(HCode3, 'Value');

set(HCode3, 'UserData', Code3)


%% Case = Enter
% This section of code allows you to enter the secret code and it checks to
% see if the code is correct. If so, it turns the room number green at the
% bottom of the GUI window.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'Enter'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HCode1      = findobj('Tag','CodeValue1');
HCode2      = findobj('Tag','CodeValue2');
HCode3      = findobj('Tag','CodeValue3');
HEnter      = findobj('Tag','Enter');


HRoom1Solved   = findobj('Tag','Room1Solved');
HRoom2Solved   = findobj('Tag','Room2Solved');
HRoom3Solved   = findobj('Tag','Room3Solved');
HRoom4Solved   = findobj('Tag','Room4Solved');
HRoom5Solved   = findobj('Tag','Room5Solved');
HRoom6Solved   = findobj('Tag','Room6Solved');
HPenaltyTime = findobj('Tag', 'PenaltyTime');
HTotalTime = findobj('Tag', 'TotalTime');

Code1 = get(HCode1, 'UserData')-2;
Code2 = get(HCode2, 'UserData')-2;
Code3 = get(HCode3, 'UserData')-2;

Room = get(HRoomName, 'UserData')-1;

if Room == 5
    Codes = [3 8 13 18 23 11 12 13 14 15 13 13 13 13 13];
    Code1Num = Codes(Num1);
    Code2Num = Codes(Num2);
    Code3Num = Codes(Num3);
end

if Room == 6
    Codes = [1 2 3 4 5 6 9 10];
    Code1Num = Codes(Num1);
    Code2Num = Codes(Num2);
    Code3Num = Codes(Num3);
end

if Room == 1 & Code1 == Num1 & Code2 == Num2 & Code3 == Num3
    set(HRoom1Solved, 'BackgroundColor', 'green')
    set(HRoom1Solved, 'UserData', 1)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'Off')
    
    set(HCode1, 'Value', 1)
    set(HCode2, 'Value', 1)
    set(HCode3, 'Value', 1)

elseif Room == 2 & Code1 == Num1 & Code2 == Num2 & Code3 == Num3
    set(HRoom2Solved, 'BackgroundColor', 'green')
    set(HRoom2Solved, 'UserData', 1)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'Off')
    
    set(HCode1, 'Value', 1)
    set(HCode2, 'Value', 1)
    set(HCode3, 'Value', 1)

elseif Room == 3 & Code1 == Num1 & Code2 == Num2 & Code3 == Num3
    set(HRoom3Solved, 'BackgroundColor', 'green')
    set(HRoom3Solved, 'UserData', 1)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'Off')
    
    set(HCode1, 'Value', 1)
    set(HCode2, 'Value', 1)
    set(HCode3, 'Value', 1)

elseif Room == 4 & Code1 == Num1 & Code2 == Num2 & Code3 == Num3
    set(HRoom4Solved, 'BackgroundColor', 'green')
    set(HRoom4Solved, 'UserData', 1)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'Off')
    
    set(HCode1, 'Value', 1)
    set(HCode2, 'Value', 1)
    set(HCode3, 'Value', 1)
    
elseif Room == 5 & Code3 == Code3Num
    set(HRoom5Solved, 'BackgroundColor', 'green')
    set(HRoom5Solved, 'UserData', 1)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'Off')
    
    set(HCode1, 'Value', 1)
    set(HCode2, 'Value', 1)
    set(HCode3, 'Value', 1)
    
elseif Room == 5 & Code2 == Code2Num
    files = {'MRI_GRE_TE3.png','MRI_GRE_TE8.png','MRI_GRE_TE13.png', ...
             'MRI_GRE_TE18.png','MRI_GRE_TE23.png','MRI_GREy_TE11.png',...
             'MRI_GREy_TE12.png','MRI_GREy_TE13.png','MRI_GREy_TE14.png',...
             'MRI_GREy_TE15.png','MRI_Spiral1_TE13.png','MRI_Spiral2_TE13.png',...
             'MRI_Spiral3_TE13.png','MRI_Spiral4_TE13.png','MRI_Spiral5_TE13.png'};
    filename = strcat(pwd, '/MRI/', files{1,Num3});
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other.
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
    
    set(HCode2, 'UserData', 0)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'On')

elseif Room == 5 & Code1 == Code1Num
    files = {'MRI_GRE_TE3.png','MRI_GRE_TE8.png','MRI_GRE_TE13.png', ...
             'MRI_GRE_TE18.png','MRI_GRE_TE23.png','MRI_GREy_TE11.png',...
             'MRI_GREy_TE12.png','MRI_GREy_TE13.png','MRI_GREy_TE14.png',...
             'MRI_GREy_TE15.png','MRI_Spiral1_TE13.png','MRI_Spiral2_TE13.png',...
             'MRI_Spiral3_TE13.png','MRI_Spiral4_TE13.png','MRI_Spiral5_TE13.png'};
    filename = strcat(pwd, '/MRI/', files{1,Num2});
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other.
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
    
    set(HCode1, 'UserData', 0)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'On')
    set(HCode3, 'Enable', 'Off')

elseif Room == 6 & Code3 == Code3Num
    set(HRoom6Solved, 'BackgroundColor', 'green')
    set(HRoom6Solved, 'UserData', 1)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'Off')
    
    set(HCode1, 'Value', 1)
    set(HCode2, 'Value', 1)
    set(HCode3, 'Value', 1)

elseif Room == 6 & Code2 == Code2Num
    files = {'PET_I2.png','PET_II2.png','PET_III2.png','PET_IV2.png',...
             'PET_V2.png','PET_VI2.png','PET_IX2.png','PET_X2.png',};
    filename = strcat(pwd, '/NuclearMedicine/', files{1,Num3});
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other.
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
    
    set(HCode2, 'UserData', 0)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'Off')
    set(HCode3, 'Enable', 'On')
    
elseif Room == 6 & Code1 == Code1Num
    files = {'PET_I2.png','PET_II2.png','PET_III2.png','PET_IV2.png',...
             'PET_V2.png','PET_VI2.png','PET_IX2.png','PET_X2.png',};
    filename = strcat(pwd, '/NuclearMedicine/', files{1,Num2});
    
    % Displays puzzle on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other.
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal

    set(HCode1, 'UserData', 0)
    set(HCode1, 'Enable', 'Off')
    set(HCode2, 'Enable', 'On')
    set(HCode3, 'Enable', 'Off')
    
else
    NumWrongAnswers = NumWrongAnswers + 1
    PenaltyTimeStr = get(HPenaltyTime, 'String');
    if iscell(PenaltyTimeStr)
        PenaltyTimeStr = PenaltyTimeStr{1};
    end
    C = strsplit(PenaltyTimeStr,':');
    Cmin = str2double(C(1));
    Csec = str2double(C(2));
    if mod(NumWrongAnswers, 2) == 0
        PenaltyTimeStrNew = strcat(num2str(Cmin+1), ':00');
    else
        PenaltyTimeStrNew = strcat(num2str(Cmin), ':', num2str(Csec + 30));
    end
    set(HPenaltyTime, 'String', PenaltyTimeStrNew);
        
end

Room1Solved = get(HRoom1Solved, 'UserData');
Room2Solved = get(HRoom2Solved, 'UserData');
Room3Solved = get(HRoom3Solved, 'UserData');
Room4Solved = get(HRoom4Solved, 'UserData');
Room5Solved = get(HRoom5Solved, 'UserData');
Room6Solved = get(HRoom6Solved, 'UserData');

RoomsSolved = Room1Solved + Room2Solved + Room3Solved + ...
              Room4Solved + Room5Solved + Room6Solved;

if RoomsSolved == 6
    stop(htimer)
    PenaltyTimeStr = get(HPenaltyTime, 'String');
    if iscell(PenaltyTimeStr)
        PenaltyTimeStr = PenaltyTimeStr{1};
    end
    C = strsplit(PenaltyTimeStr,':');
    Cmin = str2double(C(1));
    Csec = str2double(C(2));
    
    
    time_elapsed = etime(clock,T1);
    str = formatTimeFcn(TIME + time_elapsed);
    if iscell(str)
        str = str{1};
    end
    TT = strsplit(str,':');
    TTmin = str2double(TT(1));
    TTsec = str2double(TT(2));
    
    MinNew = num2str(59 + Cmin - TTmin);
    SecNew = num2str(60 + Csec - TTsec);
    
    if length(SecNew) == 1
        TotalTimeStrNew = strcat(MinNew, ':0', SecNew);
    else
        TotalTimeStrNew = strcat(MinNew, ':', SecNew);
    end 
    
    set(HTotalTime,'String',TotalTimeStrNew);
    
    % Displays Escape Room Exit image on primary axis (ax) of GUI
    % Note: The subplot syntax "subplot(1,1,1)" was necessary to avoid a
    % weird issue where the images kept overlapping each other.
    filename = strcat(pwd, '/EscapeRoomExit.png');
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
    
    IM = imread(strcat(pwd, '/EscapeRoomCard.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end

%% Case = Timer
% This section of code starts the countdown timer so that the player knows
% how much time they have left. It also enables the player to select a room
% name from the drop-down menu once the game begins.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'Timer'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HTimer      = findobj('Tag','Timer');

T1 = clock;
TIME = 0;
STOPPED = 1;
LAPFLAG = 0;

    if LAPFLAG
        T2 = clock;
        time_elapsed = etime(T2,T1);
        T1 = T2;
        TIME = TIME + time_elapsed;
    else
        T1 = clock;
    end
    STOPPED = 0;

set(HTimer, 'BackgroundColor', [0 0 0]);

% Process Inputs
input = -3599;
var = [];
if isscalar(input)
    TIME = input;
elseif length(var{1}) == 6
    target_time = var{1};
    TIME = etime(T1,target_time);
    STOPPED = 0;
end
str = formatTimeFcn(TIME);

% Start the Timer 
htimer = timer('TimerFcn',@timerFcn,'Period',0.001,'ExecutionMode','FixedRate');
start(htimer);

set(HTimer, 'Enable', 'Off');
set(HRoomName, 'Enable', 'On');

%% Case = Hint1
% This section of code displays the first hint card when the player requests
% it. It also adds a penalty time based on how many hints the player has 
% used, and it enables the user player to request the second hint, if they
% so desire.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'Hint1'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HHint1      = findobj('Tag','Hint1');
HHint2      = findobj('Tag', 'Hint2');
HPenaltyTime = findobj('Tag', 'PenaltyTime');

Room = get(HRoomName, 'UserData')-1;

if Room == 1
    IM = imread(strcat(pwd, '/SignalsSystems/', 'Hint1.png'));
    axes(ax2); 
    image(IM);
    axis image
    axis off
elseif Room == 2
    IM = imread(strcat(pwd, '/XRay/', 'Hint1.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 3
    IM = imread(strcat(pwd, '/CT/', 'Hint1.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 4
    IM = imread(strcat(pwd, '/Ultrasound/', 'Hint1.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 5
    IM = imread(strcat(pwd, '/MRI/', 'Hint1.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 6
    IM = imread(strcat(pwd, '/NuclearMedicine/', 'Hint1.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end


PenaltyTimeStr = get(HPenaltyTime, 'String');
if iscell(PenaltyTimeStr)
    PenaltyTimeStr = PenaltyTimeStr{1};
end
C = strsplit(PenaltyTimeStr,':');
Cmin = str2double(C(1));
NumHints = NumHints + 1;
PenaltyTimeStrNew = strcat(num2str(Cmin + NumHints), ':', C(2));

set(HPenaltyTime, 'String', PenaltyTimeStrNew);
set(HHint1, 'Enable', 'Off')
set(HHint2, 'Enable', 'On')

%% Case = Hint2
% This section of code displays the second hint card when the player requests
% it. It also adds a penalty time based on how many hints the player has 
% used, and it enables the user player to request the solution, if they
% so desire.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'Hint2'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HHint2      = findobj('Tag', 'Hint2');
HSolution   = findobj('Tag','Solution');
HPenaltyTime = findobj('Tag', 'PenaltyTime');

Room = get(HRoomName, 'UserData')-1;

if Room == 1
    IM = imread(strcat(pwd, '/SignalsSystems/', 'Hint2.png'));
    axes(ax2); 
    image(IM);
    axis image
    axis off
elseif Room == 2
    IM = imread(strcat(pwd, '/XRay/', 'Hint2.png'));
    axes(ax2); 
    image(IM);
    axis image
    axis off
elseif Room == 3
    IM = imread(strcat(pwd, '/CT/', 'Hint2.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 4
    IM = imread(strcat(pwd, '/Ultrasound/', 'Hint2.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 5
    IM = imread(strcat(pwd, '/MRI/', 'Hint2.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
elseif Room == 6
    IM = imread(strcat(pwd, '/NuclearMedicine/', 'Hint2.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
end

PenaltyTimeStr = get(HPenaltyTime, 'String');
if iscell(PenaltyTimeStr)
    PenaltyTimeStr = PenaltyTimeStr{1};
end
C = strsplit(PenaltyTimeStr,':');
Cmin = str2double(C(1));
NumHints = NumHints + 1;
PenaltyTimeStrNew = strcat(num2str(Cmin + NumHints), ':', C(2));

set(HPenaltyTime, 'String', PenaltyTimeStrNew);

set(HHint2, 'Enable', 'Off')
set(HSolution, 'Enable', 'On')

%% Case = Solution
% This section of code displays the solution card when the player requests
% it. It also adds a penalty time based on how many hints the player has 
% used, and it marks the room as being solved (room number at bottom of GUI
% turns dark green instead of lime green if solution card is used).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
case 'Solution'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HRoomName   = findobj('Tag', 'RoomName');
HSolution   = findobj('Tag','Solution');
HPenaltyTime = findobj('Tag', 'PenaltyTime');

Room = get(HRoomName, 'UserData')-1;
HRoom1Solved   = findobj('Tag','Room1Solved');
HRoom2Solved   = findobj('Tag','Room2Solved');
HRoom3Solved   = findobj('Tag','Room3Solved');
HRoom4Solved   = findobj('Tag','Room4Solved');
HRoom5Solved   = findobj('Tag','Room5Solved');
HRoom6Solved   = findobj('Tag','Room6Solved');

HTotalTime = findobj('Tag', 'TotalTime');

if Room == 1
    IM = imread(strcat(pwd, '/SignalsSystems/', 'Solution.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    set(HRoom1Solved, 'UserData', 1)
    set(HRoom1Solved, 'BackgroundColor', [0, 0.5, 0])
elseif Room == 2
    IM = imread(strcat(pwd, '/XRay/', 'Solution.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    set(HRoom2Solved, 'UserData', 1)
    set(HRoom2Solved, 'BackgroundColor', [0, 0.5, 0])
elseif Room == 3
    IM = imread(strcat(pwd, '/CT/', 'Solution.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    set(HRoom3Solved, 'UserData', 1)
    set(HRoom3Solved, 'BackgroundColor', [0, 0.5, 0])
elseif Room == 4
    IM = imread(strcat(pwd, '/Ultrasound/', 'Solution.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    set(HRoom4Solved, 'UserData', 1)
    set(HRoom4Solved, 'BackgroundColor', [0, 0.5, 0])
elseif Room == 5
    IM = imread(strcat(pwd, '/MRI/', 'Solution.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    set(HRoom5Solved, 'UserData', 1)
    set(HRoom5Solved, 'BackgroundColor', [0, 0.5, 0])
elseif Room == 6
    IM = imread(strcat(pwd, '/NuclearMedicine/', 'Solution.png'));
    axes(ax2);
    image(IM);
    axis image
    axis off
    set(HRoom6Solved, 'UserData', 1)
    set(HRoom6Solved, 'BackgroundColor', [0, 0.5, 0])
end

PenaltyTimeStr = get(HPenaltyTime, 'String');
if iscell(PenaltyTimeStr)
    PenaltyTimeStr = PenaltyTimeStr{1};
end
C = strsplit(PenaltyTimeStr,':');
Cmin = str2double(C(1));
NumHints = NumHints + 1;
PenaltyTimeStrNew = strcat(num2str(Cmin + NumHints), ':', C(2));

set(HPenaltyTime, 'String', PenaltyTimeStrNew);
set(HSolution, 'Enable', 'Off')

Room1Solved = get(HRoom1Solved, 'UserData');
Room2Solved = get(HRoom2Solved, 'UserData');
Room3Solved = get(HRoom3Solved, 'UserData');
Room4Solved = get(HRoom4Solved, 'UserData');
Room5Solved = get(HRoom5Solved, 'UserData');
Room6Solved = get(HRoom6Solved, 'UserData');

RoomsSolved = Room1Solved + Room2Solved + Room3Solved + ...
              Room4Solved + Room5Solved + Room6Solved;

if RoomsSolved == 6
    stop(htimer)
    PenaltyTimeStr = get(HPenaltyTime, 'String');
    if iscell(PenaltyTimeStr)
        PenaltyTimeStr = PenaltyTimeStr{1};
    end
    C = strsplit(PenaltyTimeStr,':');
    Cmin = str2double(C(1));
    Csec = str2double(C(2));
    
    
    time_elapsed = etime(clock,T1);
    str = formatTimeFcn(TIME + time_elapsed);
    if iscell(str)
        str = str{1};
    end
    TT = strsplit(str,':');
    TTmin = str2double(TT(1));
    TTsec = str2double(TT(2));
    
    MinNew = num2str(59 + Cmin - TTmin);
    SecNew = num2str(60 + Csec - TTsec);
    
    if length(SecNew) == 1
        TotalTimeStrNew = strcat(MinNew, ':0', SecNew);
    else
        TotalTimeStrNew = strcat(MinNew, ':', SecNew);
    end 
    
    set(HTotalTime,'String',TotalTimeStrNew);
    
    filename = strcat(pwd, '/EscapeRoomExit.png');
    ax = axes(RoomImage, 'Units', 'normalized', 'Position', [0 0 1 1]);
    axes(ax);
    cla
    subplot(1,1,1)
    imshow(filename);
    axis equal
end

end


%% Function Call that Generates Countdown Timer
function timerFcn(varargin)
        if ~STOPPED
            time_elapsed = etime(clock,T1);
            str = formatTimeFcn(TIME + time_elapsed);
            set(HTimer,'String',str);
        end
end

%% Function Call that Converts the Time into Minutes:Seconds Format
function str = formatTimeFcn(float_time)
    % Format the Time String
    float_time = abs(float_time);
    hrs = floor(float_time/3600);
    mins = floor(float_time/60 - 60*hrs);
    secs = float_time - 60*(mins + 60*hrs);
    m = sprintf('%1.0f:',mins);
    s = sprintf('%1.0f',secs);
    if mins < 10
        m = sprintf('0%0.0f:',mins);
    end
    if secs < 9.9995
        s = sprintf('0%0.0f',secs);
    end
    str = [m s];
end

%% Function Call that Allows the User to Exit the Game
function closeRequestFcn(varargin)
    % Stop the Timer
    try
        stop(htimer)
        delete(htimer)
    catch
        closereq;
    end
    closereq;
end

%% Function Call that Specifies the Game Rules in a Pop-Up Window (from the Menu Bar)
function gameRulesFcn(varargin)
        msgbox({'Game Rules:', ...
                '1. When you are ready to begin, press the start button in the top right corner of your screen. This will start a 60-minute timer.', ...
                '', '2. You can navigate between rooms using the drop-down menu called ''ROOM NAME.'' You do not have to escape the rooms in order.', ...
                '', '3. When you have entered the correct room code, the room number at the bottom of your screen will change from red to green. The timer will stop when all room numbers are green.', ...
                '', '4. If you get stuck, you may use up to two hints per room. If these hints are not enough to help you determine the room code, you can automatically exit the room by requesting the solution. However, each help card (including the solution) will add a penalty equal to the total number of hints you have used onto your final time, so use these wisely.'}, ...
                'Game Rules');
end

%% Function Call that Specifies the Game Details in a Pop-Up Window (from the Menu Bar)
function aboutFcn(varargin)
        msgbox({'BME 303L - Modern Diagnostic Imaging Systems Escape Room', ...
                '', 'Created by: Lauren Heckelman, Matt Holbrook, and Dr. Elizabeth Bucholz',...
                '', 'Duke University Biomedical Engineering'}, 'About');
end

end