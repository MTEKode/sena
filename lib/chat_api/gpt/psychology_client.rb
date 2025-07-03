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
          { role: 'system', content: 'IMPORTANTE!!! SOLO RESPONDER A TEMAS RELACIONADOS CON PSICOLOGIA!!!' },
          { role: 'system', content: 'SE BREVE CONCISO Y EMPATICO. RESPONDE SIEMPRE EN MARKDOWN' }
        ]

        conversation_history = @chat.messages.map { |msg| { role: msg.role, content: msg.content } }
        [system_message] + conversation_history + [{ role: 'user', content: current_message }] + predefined_messages
      end
    end
  end
end
