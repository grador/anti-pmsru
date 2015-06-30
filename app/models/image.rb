class Image < ActiveRecord::Base

  validates :url, presence: true, on: :create

  def self.change_image(mass,value)
    where(url: mass).each do |i|
      i.update_column(:refer, i.refer==0?value:0)
    end
  end

  def self.save(upload,user)
    name =  upload.original_filename
    str = upload.original_filename.split('.',2)
    i=0
    path = File.join(Rails.env.production?? PRODUCTION_UPLOAD_PATH : UPLOAD_PATH, name)
    while File.exist? path
      name = str[0]+"(#{i+=1})."+str[1]
      path = File.join(Rails.env.production?? PRODUCTION_UPLOAD_PATH : UPLOAD_PATH, name)
    end
    return create(user: user.id, refer: 0, url: name, status: 1 ) if File.open(path, 'wb') { |f| f.write(upload.read) }
    false
  end

  def self.clean_up_image
    garbage = where(refer: 0).where("updated_at<?",Date.yesterday)
    if garbage.length >0
      garbage.each do |g|
        path = File.join(Rails.env.production?? PRODUCTION_UPLOAD_PATH : UPLOAD_PATH, g.url)
        File.delete(path) if File.exist? path
      end
      delete(garbage.map(&:id))
    end
  end
end
