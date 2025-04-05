require 'ruby2d'
require_relative 'config'
require_relative 'game_rules'

# Window configuration
set title: "Snake Game"
set width: BOARD_WIDTH
set height: BOARD_HEIGHT

# Game variables
$snake = [[100, 100], [90, 100], [80, 100]]
$direction = 'right'
$food = [
  rand((BOARD_WIDTH / CELL_SIZE)).floor * CELL_SIZE,
  rand((BOARD_HEIGHT / CELL_SIZE)).floor * CELL_SIZE
]
$score = 0
$game_over = false

# Add a variable to track tongue visibility
$tongue_visible = false

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
        rand((BOARD_WIDTH / CELL_SIZE)).floor * CELL_SIZE,
        rand((BOARD_HEIGHT / CELL_SIZE)).floor * CELL_SIZE
      ]
      $score = 0
      $game_over = false
    end
  end
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
    $snake.each_with_index do |(x, y), index|
      if index.zero?
        # Draw the snake's head
        Square.new(
          x: x, y: y,
          size: CELL_SIZE,
          color: 'green' # Replaced 'darkgreen' with 'green'
        )
        # Draw the tongue if visible
        if $tongue_visible
          case $direction
          when 'up'
            Line.new(
              x1: x + CELL_SIZE / 2, y1: y,
              x2: x + CELL_SIZE / 2, y2: y - CELL_SIZE / 2,
              width: 2,
              color: 'red'
            )
          when 'down'
            Line.new(
              x1: x + CELL_SIZE / 2, y1: y + CELL_SIZE,
              x2: x + CELL_SIZE / 2, y2: y + CELL_SIZE + CELL_SIZE / 2,
              width: 2,
              color: 'red'
            )
          when 'left'
            Line.new(
              x1: x, y1: y + CELL_SIZE / 2,
              x2: x - CELL_SIZE / 2, y2: y + CELL_SIZE / 2,
              width: 2,
              color: 'red'
            )
          when 'right'
            Line.new(
              x1: x + CELL_SIZE, y1: y + CELL_SIZE / 2,
              x2: x + CELL_SIZE + CELL_SIZE / 2, y2: y + CELL_SIZE / 2,
              width: 2,
              color: 'red'
            )
          end
        end
      else
        # Draw the rest of the snake's body
        Square.new(
          x: x, y: y,
          size: CELL_SIZE,
          color: 'green'
        )
      end
    end

    # Toggle tongue visibility every TONGUE_TOGGLE_SPEED frames
    $tongue_visible = !$tongue_visible if (Window.frames % TONGUE_TOGGLE_SPEED).zero?

    # Move snake every GAME_SPEED frames
    if (Window.frames % GAME_SPEED).zero?
      $snake, $food, $score = move_snake($snake, $direction, $food, $score, BOARD_WIDTH, BOARD_HEIGHT, CELL_SIZE)
      if check_collision($snake)
        $game_over = true
        Text.new("Game Over! Score: #{$score}", x: 200, y: 180, size: 20)
      end
    end
  end
end

show
