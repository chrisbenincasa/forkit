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
    fraction = ((amount.remainder(1) != 0) ? float_to_frac(amount, 'hash') : amount.to_i.to_s) unless amount.nil?
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
        if (amount.remainder(1) != 0)
          formattedIngredient = "<sup>#{fraction['numerator']}</sup>&frasl;<sub>#{fraction['denominator']}</sub> #{units} of #{link_to(name, ingredient['ingredient'])}"
          if fraction['whole']
            formattedIngredient = "#{fraction['whole']}#{formattedIngredient}"
          end
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

  def float_to_frac(floatAmount, type = 'string')
    if type == 'array'
      return Rational(floatAmount, 1).to_s.split('/')
    else
      floatArray = Rational(floatAmount, 1).to_s.split('/').map(&:to_i)
      if floatArray[1].nil?
        returnHash = Hash['whole' => floatArray[0]]
      elsif (floatArray[0]/floatArray[1]).to_i > 0
        wholePart = (floatArray[0]/floatArray[1]).to_i
        returnHash = Hash["whole" => wholePart, "numerator" => floatArray[0] - (floatArray[1] * wholePart), "denominator" => floatArray[1]]
      else
        returnHash = Hash["numerator" => floatArray[0], "denominator" => floatArray[1]]
      end
      if type == 'hash'
        return returnHash.each{|k,v| returnHash[k] = v.to_s}
      else
        returnHash.each{|k,v| v.to_s}
        if returnHash.include?('numerator') && returnHash.include?('denominator')
          returnString = "#{returnHash['numerator']}/#{returnHash['denominator']}"
          if returnHash['whole']
            returnString = "#{returnHash['whole']} #{returnString}"
          end
        else
          returnString = "#{returnHash['whole']}"
        end
        return returnString
      end
    end
  end

  def is_plural?(string)
    string.pluralize == string && string.singularize != string
  end
end
