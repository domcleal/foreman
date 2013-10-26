module Authorization
  extend ActiveSupport::Concern

  included do
    before_save    :enforce_edit_permissions
    before_destroy :enforce_destroy_permissions
    before_create  :enforce_create_permissions
  end

  # We must enforce the security model
  def enforce_edit_permissions
    enforce_permissions("edit") if enforce?
  end

  def enforce_destroy_permissions
    enforce_permissions("destroy") if enforce?
  end

  def enforce_create_permissions
    enforce_permissions("create") if enforce?
  end

  # Override in model, return the plural class name used for permissions and a translated singular description
  def effective_permissions_class
    [self.class.name.tableize, self.class.name.downcase]
  end

  def enforce_permissions operation
    # We get called again with the operation being set to create
    return true if operation == "edit" and new_record?

    klasses, klass = effective_permissions_class
    return true if User.current and User.current.allowed_to?("#{operation}_#{klasses}".to_sym)

    errors.add :base, _("You do not have permission to %{operation} this %{klass}") % { :operation => operation, :klass => klass }
    @permission_failed = operation
    false
  end

  # @return false or name of failed operation
  def permission_failed?
    return false unless @permission_failed
    @permission_failed
  end

  private
  def enforce?
    return false if (User.current and User.current.admin?)
    return true  if defined?(Rake) and Rails.env == "test"
    return false if defined?(Rake)
    true
  end
end
