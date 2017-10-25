# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :environment, 'production' 
set :output, "log/whenever.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every 5.minutes do
	runner "Character.updateLadder('us','3v3')"
	runner "sleep 100; Character.updateLadder('us','2v2')"
	runner "sleep 200; Character.updateLadder('us','rbg')"
	# runner "sleep 28; Character.updateLadder('eu','3v3')"
	# runner "sleep 35; Character.updateLadder('eu','2v2')"
	# runner "sleep 42; Character.updateLadder('eu','5v5')"
	# runner "sleep 49; Character.updateLadder('eu','rbg')"
	# runner "sleep 40; Character.updateLadder('kr','3v3')"
	# runner "sleep 45; Character.updateLadder('kr','2v2')"
	# runner "sleep 48; Character.updateLadder('kr','5v5')"
	# runner "sleep 50; Character.updateLadder('kr','rbg')"
	# runner "sleep 52; Character.updateLadder('tw','3v3')"
	# runner "sleep 54; Character.updateLadder('tw','2v2')"
	# runner "sleep 56; Character.updateLadder('tw','5v5')"
	# runner "sleep 58; Character.updateLadder('tw','rbg')"
end


# Learn more: http://github.com/javan/whenever
