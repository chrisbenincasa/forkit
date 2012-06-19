module RecipesHelper
 def convertToHtml(toConvert)
    '<p>'+toConvert.gsub(/(\r\n)+/ ,'</p><p>') + '</p>'
  end
end
