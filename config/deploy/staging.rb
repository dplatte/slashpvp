set :user, "ubuntu"
server "ec2-52-35-129-154.us-west-2.compute.amazonaws.com", :app, :web, :db, :primary => true
ssh_options[:keys] = ["~/.ssh/MacbookPro.pem"]