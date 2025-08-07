module ApplicationHelper
  def polish_pluralize(count, one, few, many)
    remainder10 = count % 10
    remainder100 = count % 100

    if count == 1
      one
    elsif remainder10.between?(2, 4) && !remainder100.between?(12, 14)
      few
    else
      many
    end
  end
end