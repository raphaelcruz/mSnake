classdef snake
    properties
        pos = [13 13]
        X = 25
        Y = 25
        map = zeros(25,25);
        len = 3
        fig
    end

    methods
       
        function obj = snake
            obj.fig = figure('NumberTitle','off','Menubar','none',...
                   'Name','mSnake',...
                   'KeyPressFcn',@(src,evt)getKey(evt));
            function getKey(event)
            global key
                if event.Key == 'w' || strcmp(event.Key, 'uparrow')
                    if key ~= 's'
                        key = 'w';
                    end
                elseif event.Key == 's' || strcmp(event.Key, 'downarrow')
                    if key ~= 'w'
                        key = 's';
                    end
                elseif event.Key == 'd' || strcmp(event.Key, 'rightarrow')
                    if key ~= 'a'
                        key = 'd';
                    end
                elseif event.Key == 'a' || strcmp(event.Key,'leftarrow')
                    if key ~= 'd'
                        key = 'a';
                    end
                end

            end
        end

        function start(obj)
            while true
                obj = obj.steuern();
                obj = obj.updateMap();
                obj.drawSnake();
                pause(0.5)
            end
        end

        function obj = steuern(obj)
            global key
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
            disp(key)
        return
        end

        function obj = updateMap(obj)
            obj.map(obj.pos(1), obj.pos(2)) = obj.len + 1;
            obj.map = obj.map - 1;
            obj.map(obj.map<0) = 0;
        return
        end

        function drawSnake(obj)
            patch([1 obj.X obj.X 1], [1 1 obj.Y obj.Y], 'k')
            axis('tight')

            obj.drawSegments()

            x=obj.pos(1);
            y=obj.pos(2);
            patch([x x+1 x+1 x], [y y y+1 y+1], 'r')
        end

        function drawSegments(obj)
            [i,j] = find(obj.map>0);
            i = i'; j = j';
            patch([i; i+1 ; i+1; i], [ j; j; j+1; j+1], 'g')
        end

    end
end
