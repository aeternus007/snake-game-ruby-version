require 'ruby2d'

set title: "Snake By Ray Libbenga"
set background: "black"
set fps_cap: 10

APPLE = "fuchsia"
HEAD = "red"
BODY = "green"

WIDTH = 640
HEIGHT = 480

GRID = 20

BOUND_X = WIDTH / GRID
BOUND_Y = HEIGHT / GRID


class Snake

    attr_reader(:head)
    attr_accessor(:alive, :direction, :score)

    def initialize(grid_size)
        @size = grid_size -1
        @direction = "left"
        @alive = true
        @snake = [[22, 20], [21, 20], [20, 20]]
        @head = @snake[-1]
        @score = 0
    end

    def draw
        @snake.each_with_index do |part, i|
            if i == @snake.length() - 1
                Square.new(x: part[0] * GRID, y: part[1] * GRID, size: @size, color: HEAD)
            else
                Square.new(x: part[0] * GRID, y: part[1] * GRID, size: @size, color: BODY)
            end
        end
    end

    def update(apple_eaten)
        if @alive
            if not apple_eaten
                @snake.shift()
            end

            x, y = @snake[-1]

            case @direction
            when "up"
                new_segment = [x, (y - 1) % BOUND_Y]
            when "right"
                new_segment = [(x + 1) % BOUND_X, y]
            when "down"
                new_segment = [x, (y + 1) % BOUND_Y]
            when "left"
                new_segment = [(x- 1) % BOUND_X , y]
            end
            
            @snake << new_segment
            @head = @snake[-1]

            if @snake[0..@snake.size - 2].include?(@head)
                @alive = false
            end
        end
    end
    
end


class Apple
    
    attr_reader(:position)

    def initialize(color)
        @color = color
        @position = [rand(0...BOUND_X), rand(0...BOUND_Y)]
    end

    def draw
        Square.new(x: position[0] * GRID, y: position[1] * GRID, size: GRID, color: @color)
    end

end


def setup(grid, color)
    return Snake.new(grid), Apple.new(color)
end


player, apple = setup(GRID, APPLE)

paused = false

on :key_down do |event|
    puts event.key
    case event.key
    when "down", "s"
        unless player.direction == "up"
            player.direction = "down"
        end
    when "up", "w"
        unless player.direction == "down"
            player.direction = "up"
        end
    when "left", "a"
        unless player.direction == "right"
            player.direction = "left"
        end
    when "right", "d"
        unless player.direction == "left"
            player.direction = "right"
        end
    end

    if player.alive and event.key == "space"
        paused = !paused
    end
    if player.alive == false and event.key == "return"
        player, apple = setup(GRID, APPLE)
    end
end

update do 
    clear()

    if player.alive() and paused
        Text.new("Paused", x: 250, y: 200, style: "bold", size: 40, color: "white")
   
    elsif player.alive() and not paused
        if apple.position == player.head
            player.score += 1
            apple_eaten = true
            apple = Apple.new(APPLE)
        else
            apple_eaten = false
        end

        apple.draw()
        player.update(apple_eaten)
        player.draw()

        Text.new("#{player.score}", x: 0, y: 0, style: "bold", size: 20, color: "white")
 
    else
        Text.new("Game Over", x: 220, y: 170, style: "bold", size: 40, color: "red")
        Text.new("(Press Enter To Start Again)", x: 185, y: 230, style: "bold", size: 20, color: "red")
    end
end

show