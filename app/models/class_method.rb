module ClassMethod

  def self.included(base)
    base.extend(FirstClassMethod)
  end
  # TODO разобраться с видимостью take_katalog в data_hash
  module FirstClassMethod
    # администратор просматривает список всех пользователей
  end

end
