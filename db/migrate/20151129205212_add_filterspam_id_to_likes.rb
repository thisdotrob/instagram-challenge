class AddFilterspamIdToLikes < ActiveRecord::Migration
  def change
    add_reference :likes, :filterspam, index: true, foreign_key: true
  end
end
