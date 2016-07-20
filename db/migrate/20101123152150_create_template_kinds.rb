class CreateTemplateKinds < ActiveRecord::Migration[4.2]
  def up
    create_table :template_kinds do |t|
      t.string :name, :limit => 255
      t.timestamps
    end
  end

  def down
    drop_table :template_kinds
  end
end
