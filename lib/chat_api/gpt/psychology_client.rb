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
          model: 'gpt-4o-mini',
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

        # TODO Añadir los mensajes restantes(DE LA SESION)
        predefined_messages = [
          { role: 'system', content: 'Responde siempre de manera breve y concisa pero sin omitir informacion.' },
          { role: 'system', content: 'Responde siempre en formato MARKDOWN' },
        ]

        conversation_history = @chat.messages.map { |msg| { role: msg.role, content: msg.content } }
        [system_message] + predefined_messages + conversation_history + [{ role: 'user', content: current_message }]
      end
    end
  end
end
