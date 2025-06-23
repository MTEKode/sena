require 'http'
require 'json'

module ChatApi
  module Gpt
    class PsychologyClient
      def initialize(emoti, api_key = nil)
        @emoti = emoti
        @api_key = api_key || ENV['GPT_KEY']
        raise ArgumentError, 'Emoti is required' unless @emoti
        raise ArgumentError, 'API key is required' unless @api_key
        @conversation_history = []
      end

      def send_message(message)
        # Añadir el mensaje del usuario al historial de la conversación
        @conversation_history << { role: 'user', content: message }

        # Preparar el cuerpo de la solicitud con el historial completo
        request_body = {
          model: 'gpt-3.5-turbo',
          messages: prepare_messages(message, @emoti.prompt)
        }

        response = HTTP.headers(
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{@api_key}"
        ).post(
          'https://api.openai.com/v1/chat/completions',
          body: request_body.to_json
        )

        if response.status.success?
          parsed_response = JSON.parse(response.body.to_s)
          assistant_message = parsed_response['choices'][0]['message']['content']

          # Añadir la respuesta del asistente al historial
          @conversation_history << { role: 'assistant', content: assistant_message }

          assistant_message
        else
          { error: response.body.to_s }
        end
      rescue HTTP::Error => e
        { error: e.message }
      end

      private

      def prepare_messages(current_message, system_message)
        # Mensaje del sistema para establecer el contexto y el rol del asistente
        system_message = {
          role: 'system',
          content: <<~SYSTEM_MESSAGE
#{system_message}
          SYSTEM_MESSAGE
        }

        # Mensajes predefinidos para guiar la conversación (puedes añadirlos según sea necesario)
        predefined_messages = [
          { role: 'system', content: 'Recuerda siempre basar tus respuestas en evidencia científica y ser empático.' },
          { role: 'system', content: 'Si el usuario menciona pensamientos suicidas, proporciona recursos de emergencia y sugiere buscar ayuda inmediata.' }
        ]

        # Combinar el mensaje del sistema, los mensajes predefinidos, el historial y el mensaje actual
        [system_message] + predefined_messages + @conversation_history + [{ role: 'user', content: current_message }]
      end
    end
  end
end
