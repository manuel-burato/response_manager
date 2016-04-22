module ResponseManager
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActionView::MissingTemplate do |exception|
        raise exception if !self.responder
        if self.responder.in? :json, :xml
          success(nil, 200, { type:"NoResponse",data:nil })
        else
          raise exception
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |exception|
        error(404, exception)
      end

      rescue_from ActiveRecord::StaleObjectError do |exception|
        error(500, exception)
      end

      rescue_from ActiveRecord::RecordInvalid do |exception|
        error(422, exception)
      end

      rescue_from ActiveRecord::RecordNotSaved do |exception|
        error(422, exception)
      end

      rescue_from ActionController::RoutingError do |exception|
        error(404, exception)
      end

      rescue_from AbstractController::ActionNotFound do |exception|
        error(404, exception)
      end

      rescue_from ActionController::MethodNotAllowed do |exception|
        error(405, exception)
      end

      rescue_from ActionController::UnknownHttpMethod do |exception|
        error(405, exception)
      end

      rescue_from ActionController::NotImplemented do |exception|
        error(501, exception)
      end

      rescue_from ActionController::UnknownFormat do |exception|
        error(406, exception)
      end

      rescue_from ActionController::InvalidAuthenticityToken do |exception|
        error(422, exception)
      end

      rescue_from ActionDispatch::ParamsParser::ParseError do |exception|
        error(400, exception)
      end

      rescue_from ActionController::BadRequest do |exception|
        error(400, exception)
      end

      rescue_from ActionController::ParameterMissing do |exception|
        error(400, exception)
      end
    end
  end
end
