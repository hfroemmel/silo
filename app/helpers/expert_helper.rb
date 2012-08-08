# Provides expert specific helpers.
module ExpertHelper

  # Returns all available genders in a select box freindly format.
  #
  #   list_genders
  #   #=> [['Female', :female], ['Male', :male]]
  def list_genders
    Expert::GENDERS.collect { |g| [t(g, scope: :label), g] }
  end

  # Returns a string containing links to the CV downloads.
  #
  #   list_cvs(expert)
  #   #=> '<a href="">en</a><a href="">de</a>'
  def list_cvs(expert)
    expert.cvs.inject('') do |ret, cv|
      ret << link_to(cv.language, expert_cv_path(id: cv, expert_id: expert))
    end.html_safe
  end
end
