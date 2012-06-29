module ApplicationHelper
  def sortable(type, title = nil)
    title ||= type.titleize
    direction = type == sort_type && sort_direction == 'desc' ? 'asc' : 'desc'
    if type == sort_type
      if direction == 'asc'
        link_to title, {:sort => type, :direction => direction}, {:class => 'sorter pretty_button inline active-desc'}
      else
        link_to title, {:sort => type, :direction => direction}, {:class => 'sorter pretty_button inline active-asc'}
      end
    else
      link_to title, {:sort => type, :direction => direction}, {:class => 'sorter pretty_button inline'}
    end
  end

  def past_tense(person, noun, verb)
    if person == 1 or person == 2
      return "#{noun} have #{verb}ed"
    else
      return "#{noun} has #{verb}ed"
    end
  end

end
