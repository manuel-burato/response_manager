module ResponseManager
  class Configuration
    attr_accessor :available_responder_types, :global_default_responder_type, :error_codes, :success_codes, :error_pages, :excluded_controllers

    def initialize

    end
  end
end
