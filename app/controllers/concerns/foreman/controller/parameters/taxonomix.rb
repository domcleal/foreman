module Foreman::Controller::Parameters::Taxonomix
  def add_taxonomix_params_filter(filter)
    filter.permit :locations => [], :location_ids => [], :location_names => [],
      :organizations => [], :organization_ids => [], :organization_names => []
    filter
  end
end
