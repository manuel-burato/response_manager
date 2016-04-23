module ResponseManager
  module Respondes
    module TEXT
      def controller_std

      end

      def error(code, info = {})
        if ResponseManager.configuration.error_codes[code]
          render text: "TEXT Error" unless performed?
        end
      end

      def success(data = {}, code = 200, meta = {})
        if ResponseManager.configuration.success_codes[code]
          render text: data unless performed?
        end
      end
    end
  end
end
