module ResponseManager
  class Responder
    attr_accessor :type, :manager, :methods

    def initialize(type)
      self.type = type
      self.manager = ResponseManager.configuration.available_responder_types[self.type][:manager_class]
      self.methods = manager.get_methods
    end

    def is_json?
      self.type == :json
    end

    def is_xml?
      self.type == :xml
    end

    def is_html?
      self.type == :html
    end

    def in?(*vals)
      vals.include? self.type
    end

    def set_defaults(controller)
      self.methods['controller_std'].bind(controller).call
    end

    def error(controller, *args)
      self.methods['error'].bind(controller).call(*args)
    end

    def success(controller, *args)
      self.methods['success'].bind(controller).call(*args)
    end
  end
end
