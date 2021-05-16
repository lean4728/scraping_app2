class CreateChords < ActiveRecord::Migration[6.0]
  def change
    create_table :chords do |t|
      t.string :song
      t.string :artist
      t.string :chord1st
      t.string :chord2nd
      t.string :chord3rd
      t.string :chord4th

      t.timestamps
    end
  end
end
