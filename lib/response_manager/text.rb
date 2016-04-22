module ResponseManager::TEXT
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
      render text: "TEXT Error" unless performed?
    end
  end

  def success(data, code, meta = {})
    if ResponseManager.configuration.success_codes[code]
      render text: "TEXT Success" unless performed?
    end
  end
end
