require 'ruby2d'
require_relative 'config'
require_relative 'game_rules'
require_relative 'draw_snake'
require_relative 'draw_food'
require_relative 'game_input'

# Window configuration
set title: "Snake Game"
set width: BOARD_WIDTH
set height: BOARD_HEIGHT

# Game variables
$snake = INITIAL_SNAKE
$direction = INITIAL_DIRECTION
$food = INITIAL_FOOD
$score = INITIAL_SCORE
$game_over = INITIAL_GAME_OVER
$tongue_visible = INITIAL_TONGUE_VISIBLE

# Handle keyboard input
handle_input

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
