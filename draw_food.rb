def draw_food(food, cell_size)
  Square.new(
    x: food[0], y: food[1],
    size: cell_size,
    color: 'red'
  )
end
