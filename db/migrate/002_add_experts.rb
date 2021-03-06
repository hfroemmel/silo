class AddExperts < ActiveRecord::Migration
  def up
    create_table :experts do |t|
      t.integer     :user_id,              null: false
      t.integer     :country_id,           null: true
      t.string      :name,                 null: false
      t.string      :prename,              null: false
      t.string      :gender,               null: false
      t.date        :birthday,             null: true
      t.string      :degree,               null: true
      t.boolean     :former_collaboration, null: false, default: false
      t.string      :fee,                  null: true
      t.string      :job,                  null: true
      t.timestamps
    end

    add_index :experts, :user_id
    add_index :experts, :country_id
    add_index :experts, :name
    add_index :experts, :prename

    create_table :areas do |t|
      t.string :area, null: false
    end

    add_index :areas, :area, unique: true

    create_table :countries do |t|
      t.integer :area_id,      null: false
      t.string  :country,   null: false
    end

    add_index :countries, :area_id
    add_index :countries, :country, unique: true

    create_table :contacts do |t|
      t.references :contactable, polymorphic: true
      t.text       :contacts,    null: false
    end

    add_index :contacts, [:contactable_id, :contactable_type]

    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.integer    :country_id,  null: true
      t.text       :address,     null: false
    end

    add_index :addresses, [:addressable_id, :addressable_type]
  end

  def down
    drop_table :experts
    drop_table :areas
    drop_table :countries
    drop_table :contacts
    drop_table :addresses
  end
end
