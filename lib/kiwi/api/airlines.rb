module Kiwi
  module API
    class Airlines < Base
      def list
        wrap_response(@conn.get('/airlines'))
      end
    end
  end
end
