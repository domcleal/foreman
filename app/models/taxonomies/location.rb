class Location < Taxonomy
  extend FriendlyId
  friendly_id :title
  include Foreman::ThreadSession::LocationModel
  include Parameterizable::ByIdName

  has_many :location_organizations
  has_many :organizations, :through => :location_organizations, :dependent => :destroy
  has_many_hosts :dependent => :nullify
  before_destroy EnsureNotUsedBy.new(:hosts)

  has_many :location_parameters, :class_name => 'LocationParameter', :foreign_key => :reference_id, :dependent => :destroy, :inverse_of => :location
  has_many :default_users,       :class_name => 'User',              :foreign_key => :default_location_id
  accepts_nested_attributes_for :location_parameters, :allow_destroy => true
  include ParameterValidators

  scope :completer_scope, ->(opts) { my_locations }

  scope :my_locations, lambda { |user = User.current|
    conditions = user.admin? ? {} : sanitize_sql_for_conditions([" (taxonomies.id in (?))", user.location_and_child_ids])
    where(conditions)
  }

  def dup
    new = super
    new.organizations = organizations
    new
  end

  def lookup_value_match
    "location=#{title}"
  end

  def sti_name
    _("location")
  end
end
