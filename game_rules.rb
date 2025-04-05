def move_snake(snake, direction, food, score, board_width, board_height, cell_size)
  head_x, head_y = snake.first

  case direction
  when 'up'    then head_y -= cell_size
  when 'down'  then head_y += cell_size
  when 'left'  then head_x -= cell_size
  when 'right' then head_x += cell_size
  end

  # Wrap around the screen
  head_x = 0 if head_x >= board_width
  head_x = board_width - cell_size if head_x < 0
  head_y = 0 if head_y >= board_height
  head_y = board_height - cell_size if head_y < 0

  snake.unshift([head_x, head_y])

  if head_x == food[0] && head_y == food[1]
    score += 1
    food = [
      rand((board_width / cell_size)).floor * cell_size,
      rand((board_height / cell_size)).floor * cell_size
    ]
  else
    snake.pop
  end

  [snake, food, score]
end

def check_collision(snake)
  head = snake.first
  snake[1..-1].include?(head)
end
