class AddCompanyToLinks < ActiveRecord::Migration[5.2]
  def change
    change_table :links do |t|
      t.integer :company_id
    end
  end
end
