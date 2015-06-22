class Message < ActiveRecord::Base
  has_many :letters

  def self.take_catalog(user)
    where({ user: [user.id, 0]}).select(:id,:user,:theme,:text,:status,:language).order('user DESC').as_json
  end

  def insert_info_if_need(letter)
    need_name_in_text = self.text.index('<N>')
    need_name_in_theme = self.theme.index('<N>')
    need_data_in_text = self.text.index('<D>')
    need_data_in_theme = self.theme.index('<D>')
    if need_data_in_text || need_data_in_theme
      date = next_date(letter.event)
      self.text.gsub!(/<D>/,date.strftime('%d-%m-%Y')) if need_data_in_text
      self.theme.gsub!(/<D>/,date.strftime('%d-%m-%Y')) if need_data_in_theme
    end
    if need_name_in_text || need_name_in_theme
      name = letter.friend.name
      self.text.gsub!(/<N>/,name) if need_name_in_text
      self.theme.gsub!(/<N>/,name) if need_name_in_theme
    end
    self
  end
end
