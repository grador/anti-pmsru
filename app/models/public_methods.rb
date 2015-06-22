module PublicMethods

  def is_today_in_sec?(event)
    event.shift_day == sec_to_ai_periods(Date.today.to_time-event.begin_date.to_time,sec_to_ai_days(period_day(event))[0])[2]
  end

  def day_to_mail?(event)
    Date.today == next_date(event) - event.shift_day
  end

  def next_date(event)
    dt = event.begin_date
    date_today = Date.today
    period = period_day(event)
    while date_today > dt
      dt += period
    end
    dt
  end

  def allowed_editing?
    self && self.id>MAX_ID_DEMO
  end

  def period_day(event)
    case event.period
      when 'cycle'
        return event.color.days
      when 'year'
        return 1.year
      when 'month'
        return 1.month
      when 'week'
        return 1.week
      else
        return 0.day
    end
  end

  def sec_to_ai_days(sec)
    [sec.to_i/86400,sec.to_i%86400]
    #   0-целых дней, 1-остаток секунд
  end

  def sec_to_ai_periods(sec,period)
    days = sec_to_ai_days(sec)
    d1 = days[0]%period
    [days[0]/period,d1,period-d1,days[1]]
    #  0-целое колво периодов, 1-остаток от деления, 2-дней до целого периода(shift), 3-остаток секунд
  end

end