require 'response_manager/version'
require 'response_manager/configuration'
require 'response_manager/error_handler'
require 'response_manager/json'
require 'response_manager/html'
require 'response_manager/responder'
require 'response_manager/text'
require 'response_manager/xml'
require 'json'

module ResponseManager
  extend ActiveSupport::Concern

  def error *a
    self.responder.error(self, *a)
  end

  def success *a
    self.responder.success(self, *a)
  end

  def self.load request
    self.raise_custom "Error loading configuration" unless self.configuration

    target_controller_instance = request.env['action_controller.instance']
    target_controller = target_controller_instance.class

    return if self.controller_is_excluded? target_controller_instance

    loader_controller = caller_locations(1,1)[0].base_label.gsub(/[<>]/, '').gsub('class:','').constantize rescue nil

    self.raise_custom "Error detecting loader controller" unless loader_controller
    self.raise_custom "Controller #{loader_controller.name} not enabled to load ResponseManager" unless self.configuration.controller_entry_points.include? loader_controller.name

    # TODO: da verificare se questo controllo sia veramente necessario
    if target_controller.ancestors.include?(loader_controller)
      loader_controller.responder = nil
      accepted = target_controller::Accepted_content_types
      default = target_controller::Default_content_type

      self.configuration.available_responder_types.each do |key,val|
        if val[:content_types].include?(request.content_type) and accepted.include?(key)
          self.run(key, loader_controller)
        end
      end

      unless loader_controller.responder.is_a?(Responder)
        self.run(default, loader_controller)
      end
    else
      self.raise_custom "The #{controller.name} is not a child of #{loader_controller}"
    end
  end

  def self.run(sym, loader_controller)
    loader_controller.include ResponseManager
    loader_controller.responder = Responder.new sym
    loader_controller.responder.set_defaults loader_controller
  end

  def self.raise_custom exception
    raise exception
  end

  def self.controller_is_excluded? controller
    case self.configuration.excluded_controllers
      when Array
        self.configuration.excluded_controllers.include? controller.class.name
      when Proc
        self.configuration.excluded_controllers.call(controller)
      else
        false
    end
  end

  included do
    include ErrorHandler
    class_attribute :responder
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Rails.configuration.x.response_manager.configuration
  end

  def self.configure
    @configuration = Configuration.new
    yield(configuration) if block_given?
    Rails.configuration.x.response_manager.configuration = @configuration
  end
end
