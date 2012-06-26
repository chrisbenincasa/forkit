module RecipesHelper
  def convertToHtml(toConvert)
    '<p>'+toConvert.gsub(/(\r\n)+/ ,'</p><p>') + '</p>'
  end

  def formatted_cook_time_string(cook_string)
    if cook_string.nil?
      return ''
    else
      times = cook_string.split(/\D/)
      return [pluralize(times[0], 'day'), pluralize(times[1], 'hour'), pluralize(times[2], 'minute')].join(', ')
    end
  end
end
