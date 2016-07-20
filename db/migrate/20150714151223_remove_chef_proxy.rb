class RemoveChefProxy < ActiveRecord::Migration[4.2]
  def up
    Feature.delete_all("name = 'Chef Proxy'")
  end

  def down
    Feature.where(:name => "Chef Proxy").first_or_create!
  end
end
