class AddConfirmableToDevise < ActiveRecord::Migration
  def change
  end
  
  def self.up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
   
    User.update_all(:confirmed_at => Time.now)
    # All existing user accounts should be able to log in after this.
  end
  
  def self.down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    # remove_columns :users, :unconfirmed_email # Only if using reconfirmable
  end
  
end
