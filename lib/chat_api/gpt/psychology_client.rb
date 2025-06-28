module ChatApi
  module Gpt
    class PsychologyClient < Client
      def initialize(chat)
        super()
        @chat = chat
        raise ArgumentError, 'Chat is required' unless @chat
      end

      def send_message(message)
        request_body = {
          model: 'gpt-3.5-turbo',
          messages: prepare_messages(message)
        }
        send_request(request_body)
      end

      private

      def prepare_messages(current_message)
        system_message = {
          role: 'system',
          content: "#{@chat.emoti.prompt}"
        }

        predefined_messages = [
          { role: 'system', content: 'Recuerda siempre basar tus respuestas en evidencia científica y ser empático.' },
          { role: 'system', content: 'Si el usuario menciona pensamientos suicidas, proporciona recursos de emergencia y sugiere buscar ayuda inmediata.' }
        ]

        conversation_history = @chat.messages.map { |msg| { role: msg.role, content: msg.content } }
        [system_message] + predefined_messages + conversation_history + [{ role: 'user', content: current_message }]
      end
    end
  end
end
