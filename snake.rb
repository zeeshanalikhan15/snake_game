require 'ruby2d'
require_relative 'config'

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

def move_snake
  head_x, head_y = $snake.first

  case $direction
  when 'up'    then head_y -= CELL_SIZE
  when 'down'  then head_y += CELL_SIZE
  when 'left'  then head_x -= CELL_SIZE
  when 'right' then head_x += CELL_SIZE
  end

  # Wrap around the screen
  head_x = 0 if head_x >= BOARD_WIDTH
  head_x = BOARD_WIDTH - CELL_SIZE if head_x < 0
  head_y = 0 if head_y >= BOARD_HEIGHT
  head_y = BOARD_HEIGHT - CELL_SIZE if head_y < 0

  $snake.unshift([head_x, head_y])

  if head_x == $food[0] && head_y == $food[1]
    $score += 1
    $food = [
      rand((BOARD_WIDTH / CELL_SIZE)).floor * CELL_SIZE,
      rand((BOARD_HEIGHT / CELL_SIZE)).floor * CELL_SIZE
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
      move_snake
      if check_collision
        $game_over = true
        Text.new("Game Over! Score: #{$score}", x: 200, y: 180, size: 20)
      end
    end
  end
end

show
