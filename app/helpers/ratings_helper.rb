module RatingsHelper
  def rating_table(characters, field, current = current_character, include_current = true, &block)
    result = ""

    characters.each_with_index do |character, index|
      position = field ? characters.index{|c| c.send(field) == character.send(field) } : index

      result << capture(character, position + 1, (character == current), &block)
    end

    if include_current && current && !characters.include?(current)
      position = characters.rating_position(current, field)

      result << capture(current, position, true, &block)
    end

    block_given? ? concat(result.html_safe) : result.html_safe
  end
end
