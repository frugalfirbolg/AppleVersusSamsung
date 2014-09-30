class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :name
      t.string :shortDescription
      t.string :largeImage
      t.string :manufacturer
      t.decimal :regularPrice
      t.integer :bestSellingRank
      t.integer :salesRankShortTerm
      t.integer :salesRankMediumTerm
      t.integer :salesRankLongTerm
      t.integer :classId

      t.timestamps
    end
  end
end
