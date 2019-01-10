class CreateCallLists < ActiveRecord::Migration[5.1]
  def change
    create_table :call_lists do |t|
      t.string :custcode
      t.string :custname
      t.string :contact_method
      t.string :contact
      t.string :phone
      t.string :email
      t.string :selling
      t.string :main_phone
      t.string :website
      t.string :rep

      t.timestamps
    end
  end
end
