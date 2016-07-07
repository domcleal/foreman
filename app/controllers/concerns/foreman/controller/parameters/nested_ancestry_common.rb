module Foreman::Controller::Parameters::NestedAncestryCommon
  def add_nested_ancestry_params_filter(filter)
    filter.permit :parent, :parent_id
    filter
  end
end
