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
every 24.minutes do
	runner "Character.updateLadder('us','3v3')"
	runner "sleep 120; Character.updateLadder('us','2v2')"
	runner "sleep 240; Character.updateLadder('us','rbg')"
	runner "sleep 360; Character.updateLadder('eu','3v3')"
	runner "sleep 480; Character.updateLadder('eu','2v2')"
	runner "sleep 600; Character.updateLadder('eu','rbg')"
	runner "sleep 720; Character.updateLadder('kr','3v3')"
	runner "sleep 840; Character.updateLadder('kr','2v2')"
	runner "sleep 960; Character.updateLadder('kr','rbg')"
	runner "sleep 1080; Character.updateLadder('tw','3v3')"
	runner "sleep 1200; Character.updateLadder('tw','2v2')"
	runner "sleep 1320; Character.updateLadder('tw','rbg')"
end


# Learn more: http://github.com/javan/whenever
