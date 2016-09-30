module UsersHelper
 # 返回指定用户的 Gravatar
   def gravatar_for(user,args={size:80})
     gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
     size=args[:size]
     gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
     image_tag(gravatar_url, alt: user.name, class: "gravatar")
    
    # "https://s.gravatar.com/avatar/add6d3c82f3610122dc46a4cabcb2a5b?s=80"
    # gravatar_url = "https://s.gravatar.com/avatar/#{gravatar_id}?s=80"
    # image_tag(gravatar_url, alt: user.name, class: "gravatar",size:args[:size])
   end
end
