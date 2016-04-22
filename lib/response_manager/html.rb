module ResponseManager::HTML
  def self.get_methods
    {
      "error" => instance_method(:error),
      "success" => instance_method(:success),
      "controller_std" => instance_method(:controller_std)
    }
  end

  def controller_std
    
  end

  def error(code, info = {})
    if ResponseManager.configuration.error_codes[code]
      render text: "HTML Error" unless performed?
    end
  end

  def success(data = {}, code = 200, meta = {})
    if ResponseManager.configuration.success_codes[code]
      render data, status: code unless performed?
    end
  end
end
