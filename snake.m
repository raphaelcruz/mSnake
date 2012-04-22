function snake
    figure('NumberTitle','off','Menubar','none',...
           'Name','mSnake',...
           'KeyPressFcn',@(obj,evt)getKey(evt));
return

function getKey(key)
    disp(key.Key)
return