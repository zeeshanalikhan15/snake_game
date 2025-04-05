def draw_snake(snake, direction, tongue_visible, cell_size)
  snake.each_with_index do |(x, y), index|
    if index.zero?
      # Draw the snake's head
      Square.new(
        x: x, y: y,
        size: cell_size,
        color: 'green'
      )
      # Draw the tongue if visible
      if tongue_visible
        case direction
        when 'up'
          Line.new(
            x1: x + cell_size / 2, y1: y,
            x2: x + cell_size / 2, y2: y - cell_size / 2,
            width: 2,
            color: 'red'
          )
        when 'down'
          Line.new(
            x1: x + cell_size / 2, y1: y + cell_size,
            x2: x + cell_size / 2, y2: y + cell_size + cell_size / 2,
            width: 2,
            color: 'red'
          )
        when 'left'
          Line.new(
            x1: x, y1: y + cell_size / 2,
            x2: x - cell_size / 2, y2: y + cell_size / 2,
            width: 2,
            color: 'red'
          )
        when 'right'
          Line.new(
            x1: x + cell_size, y1: y + cell_size / 2,
            x2: x + cell_size + cell_size / 2, y2: y + cell_size / 2,
            width: 2,
            color: 'red'
          )
        end
      end
    else
      # Draw the rest of the snake's body
      Square.new(
        x: x, y: y,
        size: cell_size,
        color: 'green'
      )
    end
  end
end
