class LocationOrganization < ActiveRecord::Base
  self.table_name = 'locations_organizations'

  belongs_to :location
  belongs_to :organization
end
