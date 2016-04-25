module ResponseManager
  class Responsinator
    attr_accessor :type, :manager, :methods, :target_controller

    def initialize(type, target_controller)
      self.type = type
      self.target_controller = target_controller
      self.manager = ResponseManager.configuration.available_responder_types[self.type][:manager_class]
       self.manager.module_eval do
         def self.get_methods
          {
            "error" => instance_method(:error),
            "success" => instance_method(:success),
            "controller_std" => instance_method(:controller_std)
          }
        end
      end
      self.methods = self.manager.get_methods
      self.methods['controller_std'].bind(self.target_controller).call

      if defined? self.manager::Content_type
        target_controller.class_eval "after_action do |controller|
          controller.content_type = '#{self.manager::Content_type}'
        end"
      end
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

    def error(*args)
      self.methods['error'].bind(self.target_controller).call(*args)
    end

    def success(*args)
      self.methods['success'].bind(self.target_controller).call(*args)
    end
  end
end
