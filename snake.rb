require 'ruby2d'

# Window configuration
set title: "Snake Game"
set width: 600
set height: 400
CELL_SIZE = 20

# Game variables
$snake = [[100, 100], [90, 100], [80, 100]]
$direction = 'right'
$food = [
  rand((Window.width / CELL_SIZE)).floor * CELL_SIZE,
  rand((Window.height / CELL_SIZE)).floor * CELL_SIZE
]
$score = 0
$game_over = false

# Handle keyboard input
on :key_down do |event|
  case event.key
  when 'up'    then $direction = 'up'    if $direction != 'down'
  when 'down'  then $direction = 'down'  if $direction != 'up'
  when 'left'  then $direction = 'left'  if $direction != 'right'
  when 'right' then $direction = 'right' if $direction != 'left'
  when 'escape' then close
  when 'f2'
    if $game_over
      $snake = [[100, 100], [90, 100], [80, 100]]
      $direction = 'right'
      $food = [
        rand((Window.width / CELL_SIZE)).floor * CELL_SIZE,
        rand((Window.height / CELL_SIZE)).floor * CELL_SIZE
      ]
      $score = 0
      $game_over = false
    end
  end
end

def move_snake
  head_x, head_y = $snake.first

  case $direction
  when 'up'    then head_y -= CELL_SIZE
  when 'down'  then head_y += CELL_SIZE
  when 'left'  then head_x -= CELL_SIZE
  when 'right' then head_x += CELL_SIZE
  end

  # Wrap around the screen
  head_x = 0 if head_x >= Window.width
  head_x = Window.width - CELL_SIZE if head_x < 0
  head_y = 0 if head_y >= Window.height
  head_y = Window.height - CELL_SIZE if head_y < 0

  $snake.unshift([head_x, head_y])

  if head_x == $food[0] && head_y == $food[1]
    $score += 1
    $food = [
      rand((Window.width / CELL_SIZE)).floor * CELL_SIZE,
      rand((Window.height / CELL_SIZE)).floor * CELL_SIZE
    ]
  else
    $snake.pop
  end
end

def check_collision
  head = $snake.first
  $game_over = true if $snake[1..-1].include?(head)
end

update do
  unless $game_over
    clear

    # Draw food
    Square.new(
      x: $food[0], y: $food[1],
      size: CELL_SIZE,
      color: 'red'
    )

    # Draw snake
    $snake.each do |x, y|
      Square.new(
        x: x, y: y,
        size: CELL_SIZE,
        color: 'green'
      )
    end

    # Move snake every 100ms
    if (Window.frames % 10).zero?
      move_snake
      if check_collision
        $game_over = true
        Text.new("Game Over! Score: #{$score}", x: 200, y: 180, size: 20)
      end
    end
  end
end

show
