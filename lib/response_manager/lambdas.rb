module ResponseManager
  module Lambdas
    def is_html? response
      request.content_type == "text/html"
    end
    def is_json? response
      request.content_type == "application/json"
    end
    def is_xml? response
      request.content_type == "application/xml"
    end
    def is_text? response
      request.content_type == "text/plain"
    end
  end
end
