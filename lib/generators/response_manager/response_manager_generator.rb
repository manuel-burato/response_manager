class ResponseManagerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  # class_option :option, :type => :boolean, :default => false, :description => ""

  def generate
    init
    gen_initializer
    finalize
  end

  private
    def init

    end

    def gen_initializer

    end

    def finalize

    end
end
