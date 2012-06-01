class AdditionalRecipeInfo < ActiveRecord::Migration
  def change
    add_column :personal_recipe_infos, :did_create, :boolean, {:default => false}
    drop_table :ratings
  end
end
