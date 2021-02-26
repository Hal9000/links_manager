class SetDatabaseDefaults < ActiveRecord::Migration[6.0]

  def up
    case ActiveRecord::Base.connection.adapter_name
    when "MySQL", "Mysql2"
      execute "ALTER DATABASE #{current_database} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci"
    when "SQLite"
      # do nothing since SQLite does not support changing the database encoding and only supports unicode charsets
    when "PostgreSQL"
      # do nothing since PostgreSQL does not support changing the database encoding
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
