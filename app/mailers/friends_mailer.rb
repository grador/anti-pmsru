class FriendsMailer < ApplicationMailer

  def ban_letter(user)
    @to = user
    mail(to: @to.email,
         from: 'no-reply@anti-pms.com',
         subject: "Блокировка аккаунта #{@to.name}.",
         template_name: 'ban_letter.txt.erb'
    )

  end
  def trace_letter(event)
    @event = event
    @to = User.find(event.user)
    @friend = @event.friend
    @reason = @event.reason
    @next_date = next_date(event)
    mail(to: @to.email,
         from: 'no-reply@anti-pms.com',
         subject: "Подтверждение даты #{@reason.name} у #{@friend.name}.",
         template_name: 'trace_letter.txt.erb'
    )
  end

  def notify_letter(letter)
    @to = letter.agent.zero? || letter.agent.nil? ? User.find(letter.user) : Agent.find(letter.agent)
    @from = letter.from
    @message = letter.message.insert_info_if_need(letter)
    mail(to:@to.email,
         from:%("#{@from.name}" <#{@from.email}>),
         subject:@message.theme,
         template_name:'notify_letter.txt.erb'
    )
  end

end
