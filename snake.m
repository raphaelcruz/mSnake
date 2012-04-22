classdef snake
    properties
        pos = [13 13]
        food = [randi([1 25]), randi([1 25])]
        X = 25
        Y = 25
        map = zeros(25,25);
        len = 3
        fig
        punkte = 0
        level
        lost = false
    end

    methods

        function obj = snake
            obj.fig = figure('NumberTitle','off','Menubar','none',...
                   'Name','mSnake',...
                   'KeyPressFcn',@(src,evt)getKey(evt));

            obj.start()
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
        end

        function start(obj)
        global level
            level = 4;
            obj.food = obj.generateFood();
            while true
                obj.level = level;
                obj = obj.steer();
                obj = obj.eat();
                obj = obj.updateMap();
                obj.drawSnake();
                if obj.lost
                    break
                end
                pause(1/level/2)
            end
        end

        function obj = steer(obj)
            global key lock
            lock = false;
            switch key
                case 'w'
                    if obj.pos(2) < obj.Y-1
                        obj.pos(2)=obj.pos(2)+1;
                    else
                        obj.pos(2)=1;
                    end
                case 's'
                    if obj.pos(2) > 1
                        obj.pos(2)=obj.pos(2)-1;
                    else
                        obj.pos(2)=obj.Y-1;
                    end
                case 'd'
                    if obj.pos(1) < obj.X-1
                        obj.pos(1)=obj.pos(1)+1;
                    else
                        obj.pos(1)=1;
                    end
                case 'a'
                    if obj.pos(1) > 1
                        obj.pos(1)=obj.pos(1)-1;
                    else
                        obj.pos(1)=obj.Y-1;
                    end
            end
        return
        end

        function obj = updateMap(obj)
            obj.map(obj.pos(1), obj.pos(2)) = obj.len + 1;
            obj.map = obj.map - 1;
            obj.map(obj.map<0) = 0;
        return
        end

        function drawSnake(obj)
            if obj.lost
                text(3, 12, 'Verloren' , 'FontSize', 72 ,'Color','r');
            else
                clf
                patch([1 obj.X obj.X 1], [1 1 obj.Y obj.Y], 'k')
                axis equal
                axis tight

                obj.drawSegments()
                obj.drawHead()

                x=obj.food(1);
                y=obj.food(2);
                patch([x x+1 x+1 x], [y y y+1 y+1], 'y')

                text( 1, 26, ['Punkte: ', num2str(obj.punkte)], 'BackgroundColor','w');
                text(16, 26, ['Länge : ', num2str(obj.len)] , 'BackgroundColor','w');
                text(11, 26, ['Level : ', num2str(obj.level)] , 'BackgroundColor','w');
            end
            drawnow
        end

        function drawSegments(obj)
            [i,j] = find(obj.map > 0);
            i = i'; j = j';
            patch([i; i+1 ; i+1; i], [ j; j; j+1; j+1], 'g')
        end

        function drawHead(obj)
        global key
            x=obj.pos(1);
            y=obj.pos(2);
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

        function obj = eat(obj)
            if obj.food(1) == obj.pos(1) && obj.food(2) == obj.pos(2)
                obj.len = obj.len + 1;
                obj.food = obj.generateFood();
                obj.punkte = obj.punkte +1*obj.level;
            end
            if obj.map(obj.pos(1), obj.pos(2))
                obj.lost = true;
            end
        end

        function newFood = generateFood(obj)
            A = obj.map;
            A(obj.pos(1),obj.pos(2))=1;
            [i,j] = find(A == 0);
            a = randi([1 length(i)]);
            newFood = [i(a) j(a)];
        return
        end

    end
end
