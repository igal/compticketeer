desc 'Setup application'
task :setup => ['db:migrate', 'setup:admin']

desc 'Setup admin user account'
task 'setup:admin' => :environment do
  password = \
    if ENV["PASSWORD"]
    ENV["PASSWORD"]
  else
    print %{?? Enter the password to use for the "admin" user: }
    STDOUT.flush
    STDIN.readline
  end.strip

  if user = User.find_by_login('admin')
    puts %{** Updated "admin" user's password}
  else
    user = User.new(:login => 'admin', :email => SECRETS.administrator_email)
    puts "** Created new 'admin' user"
  end
  user.password = user.password_confirmation = password
  user.save!
end