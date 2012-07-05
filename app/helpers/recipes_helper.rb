require 'mathn'

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

  def formatIngredient(ingredient)
    formattedIngredient = ''
    name = ingredient['ingredient'].name
    amount = ingredient['amount']
    fraction = (amount.remainder(1) != 0) ? float_to_frac(amount, true) : amount.to_i.to_s
    units = (is_plural?(ingredient['units']) ? ingredient['units'].singularize : ingredient['units']) unless (ingredient['units'].nil? or ingredient['units'].blank?)
    details = ingredient['details']
    noOf = ['whole']
    logger.debug units.nil?
    if !amount.nil? and !amount.blank?
      if units.nil? or units.blank?
        if amount > 1
          formattedIngredient = "#{fraction} #{link_to(name.pluralize, ingredient['ingredient'])}"
        else
          formattedIngredient = "#{fraction} #{link_to(name, ingredient['ingredient'])}"
        end
      elsif noOf.include?(units)
        formattedIngredient = "#{pluralize(fraction, units)} #{link_to(name, ingredient['ingredient'])}"
      else
        if amount < 1 and amount > 0
          formattedIngredient = "<sup>#{fraction[0]}</sup>&frasl;<sub>#{fraction[1]}</sub> #{units} of #{link_to(name, ingredient['ingredient'])}"
        else
          formattedIngredient = "#{pluralize(fraction, units)} of #{link_to(name, ingredient['ingredient'])}"
        end
      end
      if !details.nil? and !details.blank?
        formattedIngredient += ", #{details}"
      end
    else
      formattedIngredient = "#{link_to(name, ingredient['ingredient'])}"
    end
    return formattedIngredient
  end

  def frac_to_float(fraction)
    number1, number2 = fraction.split(/\s/)
    if number2.nil?
      numerator, denominator = number1.split('/').map(&:to_f)
      denominator ||= 1
      return numerator/denominator
    else
      numerator, denominator = number2.split('/').map(&:to_f)
      denominator ||= 1
      return number1.to_f + (numerator/denominator)
    end
  end

  def float_to_frac(floatAmount, array = false)
    if array
      return Rational(floatAmount, 1).to_s.split('/')
    else
      return Rational(floatAmount, 1)
    end
  end

  def is_plural?(string)
    string.pluralize == string && string.singularize != string
  end
end
