module ResponseManager::JSON
  def self.get_methods
    {
      "error" => instance_method(:error),
      "success" => instance_method(:success),
      "controller_std" => instance_method(:controller_std)
    }
  end

  def controller_std
    layout false
  end

  def error(code, info = {})
    if ResponseManager.configuration.error_codes[code]
      render ResponseManager::JSON.error_response(code, ResponseManager.configuration.error_codes[code], info) unless performed?
    end
  end

  def success(data, code, meta = {})
    if ResponseManager.configuration.success_codes[code]
      render ResponseManager::JSON.success_response(code, ResponseManager.configuration.success_codes[code], data, meta) unless performed?
    end
  end

  def self.error_response(code, error, others = {})
    if others.is_a?(Exception) and Rails.env.development?
        others = {
          :info => {
            class: "#{others.class.name}",
            message: "#{others.message}",
            trace: others.backtrace[0,10]
          }
        }
    end

    response = {
      type:         "error",
      code:         code.to_i,
    }

    response.merge!(error){ |key, v1, v2| v1 }
    response.merge!(others){ |key, v1, v2| v2 }

    self.response(response, code)
  end

  def self.success_response(code, success, data, others = {})
    response = {
      type:         data.class.to_s.gsub("ActiveRecord_Relation", "Array"),
      code:         code.to_i,
      data:         data
    }
    response.merge!(success){ |key, v1, v2| v1 }
    response.merge!(others){ |key, v1, v2| v2 }

    self.response(response, code)
  end

  def self.response(hsh = {}, status = 200)
    puts hsh.inspect.yellow
    return :json => hsh, status: status
  end
end
