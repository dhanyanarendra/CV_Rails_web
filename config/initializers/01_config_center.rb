module ConfigCenter
  module Default

    def self.host
      case Rails.env
      when "development"
        'http://localhost:3000'
      when "it"
        'http://it.peershape-api.qwinixtech.com'
      when "st"
        'http://st.peershape-api.qwinixtech.com'
      end
    end


    def self.fog_directory
      case Rails.env
        #Todo change this name to loanlist-development
      when "development"
        'peershape-it'
      when "it"
        'peershape-it'
      when "st"
        'peershape-st'
      end
    end
  end
end