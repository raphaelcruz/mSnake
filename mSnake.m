function mSnake
global X Y len punkte level key
    X = 25;
    Y = 25;
    len = 3;
    punkte = 0;
    level = 4 ;
    key = 'w';

    figure('NumberTitle','off','Menubar','none',...
           'Name','mSnake',...
           'KeyPressFcn',@(src,evt)getKey(evt));

    pos = [13 13];
    map = zeros(X-1,Y-1);
    food = generateFood(pos, map);

    while true
        pos = steer(pos);
        lost = testCollision(pos, map);
        food = eat(pos, food, map);
        map = updateMap(pos, map);
        drawSnake(pos, food, map);
        if lost
            text(1, 12, 'Verloren' , 'FontSize', 72 ,'Color','r');
            break
        end
        pause(1/level/2)
    end
end

function getKey(event)
global key lock level
    k = event.Key;
    if ~lock
        if strcmp(k, 'w') || strcmp(k, 'uparrow')
            if key ~= 's'
                key = 'w';
                lock = true;
            end
        elseif  strcmp(k, 's') || strcmp(k, 'downarrow')
            if key ~= 'w'
                key = 's';
                lock = true;
            end
        elseif  strcmp(k, 'd') || strcmp(k, 'rightarrow')
            if key ~= 'a'
                key = 'd';
                lock = true;
            end
        elseif  strcmp(k, 'a') || strcmp(k,'leftarrow')
            if key ~= 'd'
                key = 'a';
                lock = true;
            end
        elseif strcmp(k, 'add')
            level = level + 1;
        elseif strcmp(k, 'subtract')
            level = level - 1;
        end
    end
end

function pos = steer(pos)
    global key lock X Y
    lock = false;
    switch key
        case 'w'
            if pos(2) < Y-1
                pos(2)=pos(2)+1;
            else
                pos(2)=1;
            end
        case 's'
            if pos(2) > 1
                pos(2)=pos(2)-1;
            else
                pos(2)=Y-1;
            end
        case 'd'
            if pos(1) < X-1
                pos(1)=pos(1)+1;
            else
                pos(1)=1;
            end
        case 'a'
            if pos(1) > 1
                pos(1)=pos(1)-1;
            else
                pos(1)=Y-1;
            end
    end
end

function map = updateMap(pos, map)
global len
    map(pos(1), pos(2)) = len + 1;
    map = map - 1;
    map(map<0) = 0;
end

function drawSnake(pos, food, map)
global X Y punkte len level
    clf
    patch([1 X X 1], [1 1 Y Y], 'k')
    axis equal
    axis tight

    drawSegments(map)
    drawHead(pos)
    drawFood(food)

    text( 1, 26, ['Punkte: ', num2str(punkte)], 'BackgroundColor','w');
    text(16, 26, ['Länge : ', num2str(len)]   , 'BackgroundColor','w');
    text(11, 26, ['Level : ', num2str(level)] , 'BackgroundColor','w');
    drawnow
end

function drawSegments(map)
    [i,j] = find(map > 0);
    i = i'; j = j';
    patch([i; i+1 ; i+1; i], [ j; j; j+1; j+1], 'g')
end

function drawFood(food)
    x=food(1);
    y=food(2);
    patch([x x+1 x+1 x], [y y y+1 y+1], 'y')
end

function drawHead(pos)
global key
    x=pos(1);
    y=pos(2);
    patch([x x+1 x+1 x], [y y y+1 y+1], 'k')
    switch key
        case 'w'
            a=[x x+1 x+0.5];
            b=[y y y+1];
        case 's'
            a=[x x+1 x+0.5];
            b=[y+1 y+1 y];
        case 'd'
            a=[x x x+1];
            b=[y+1 y y+0.5];
        case 'a'
            a=[x+1 x+1 x];
            b=[y+1 y y+0.5];
    end
    scale = 1.5;
    a=(a-x-0.5)*scale+x+0.5;
    b=(b-y-0.5)*scale+y+0.5;
    patch(a,b,'g')
end

function food = eat(pos, food, map)
global len punkte level
    if food(1) == pos(1) && food(2) == pos(2)
        len = len + 1;
        food = generateFood(pos, map);
        punkte = punkte +1*level;
    end
end

function lost = testCollision(pos, map)
    lost = map(pos(1), pos(2));
end

function newFood = generateFood(pos, map)
    map(pos(1),pos(2))=1;
    [i,j] = find(map == 0);
    a = randi([1 length(i)]);
    newFood = [i(a) j(a)];
end