class AddEmailAndEmailDomainUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :email, :string
    execute <<-SQL
      CREATE UNIQUE INDEX index_users_on_email ON users(email COLLATE NOCASE);
    SQL

    add_column :users, :email_domain, :text

    User.reset_column_information
    User.find_each do |user|
      user.update_column(:email_domain, user.email.to_s.split('@').last&.downcase)
    end

    add_index :users, :email_domain
  end

  def down
    remove_index :users, :email_domain
    remove_column :users, :email_domain
    execute <<-SQL
      DROP INDEX IF EXISTS index_users_on_email;
    SQL
    remove_column :users, :email
  end
end
