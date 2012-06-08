module ApplicationHelper
  def sortable(type, title = nil)
    title ||= type.titleize
    direction = type == sort_type && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort => type, :direction => direction}, {:class => 'sorter'}
  end
end
