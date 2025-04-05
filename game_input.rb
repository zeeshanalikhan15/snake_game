require_relative 'config'

def handle_input
  on :key_down do |event|
    case event.key
    when 'up'    then $direction = 'up'    if $direction != 'down'
    when 'down'  then $direction = 'down'  if $direction != 'up'
    when 'left'  then $direction = 'left'  if $direction != 'right'
    when 'right' then $direction = 'right' if $direction != 'left'
    when 'escape' then close
    when 'f2'
      if $game_over
        $snake = INITIAL_SNAKE
        $direction = INITIAL_DIRECTION
        $food = INITIAL_FOOD
        $score = INITIAL_SCORE
        $game_over = INITIAL_GAME_OVER
      end
    end
  end
end
