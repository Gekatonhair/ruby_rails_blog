# config/initializers/scheduler.rb
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

#<секунды> <минуты> <часы> <дни> <месяцы> <дни недели>

#every day at 7:00
scheduler.cron '00 00 07 */1 * *' do
    users = User.where(:subscription => 'day').all      
    posts = Post.where("created_at >= ?", Date.today.prev_day.at_beginning_of_day)         
    users.each do |user|
        UserMailer.post_mailer(user.email, posts).deliver_now           
    end
end


#every week
scheduler.cron '00 00 07 * * 1' do
    users = User.where(:subscription => 'week').all      
    posts = Post.where("created_at >= ?", Date.today.prev_day.at_beginning_of_week)        
    users.each do |user|
        UserMailer.post_mailer(user.email, posts).deliver_now           
    end
end


#for test set '30s' (запустится через 30 секунд  после старта сервера)
scheduler.in '100d' do 
    print "\nTIME\n"
    users = User.where(:subscription => 'day').all      
    posts = Post.where("created_at >= ?", Date.today.prev_day.at_beginning_of_day)         
    users.each do |user|
        UserMailer.post_mailer(user.email, posts).deliver_now           
    end
end
