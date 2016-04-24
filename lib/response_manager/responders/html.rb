module ResponseManager
  module Respondes
    module HTML
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
  end
end
