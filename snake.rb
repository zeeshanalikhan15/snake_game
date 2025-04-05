require 'ruby2d'
require_relative 'config'
require_relative 'game_rules'
require_relative 'draw_snake'
require_relative 'draw_food'

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
    draw_food($food, CELL_SIZE)

    # Draw snake
    draw_snake($snake, $direction, $tongue_visible, CELL_SIZE)

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
