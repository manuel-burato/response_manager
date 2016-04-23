module ResponseManager
  module Lambdas
    def self.is_html? request
      request.content_type == "text/html"
    end
    def self.is_json? request
      request.content_type == "application/json"
    end
    def self.is_xml? request
      request.content_type == "application/xml"
    end
    def self.is_text? request
      request.content_type == "text/plain"
    end
  end
end
