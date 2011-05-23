class AddChimpactions < ActiveRecord::Migration
  def self.up
    create_table :chimpactions, :force => true do |t|
      t.text :action
      t.text :list
      t.string :whenn
      t.string :if
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :chimpactions
  end
end