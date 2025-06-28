require 'http'
require 'json'

module ChatApi
  module Gpt
    class PsychologyClient
      def initialize(chat, api_key = nil)
        @chat = chat
        @api_key = api_key || ENV['GPT_KEY']
        raise ArgumentError, 'Emoti is required' unless @chat
        raise ArgumentError, 'API key is required' unless @api_key
      end

      def send_message(message)
        request_body = {
          model: 'gpt-3.5-turbo',
          messages: prepare_messages(message)
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
          assistant_message
        else
          { error: response.body.to_s }
        end
      rescue HTTP::Error => e
        { error: e.message }
      end
      def send_message_choose_emoti(message)
        request_body = {
          model: 'gpt-3.5-turbo',
          messages: prepare_messages(message)
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
          assistant_message
        else
          { error: response.body.to_s }
        end
      rescue HTTP::Error => e
        { error: e.message }
      end

      private

      def prepare_messages(current_message)
        # Mensaje del sistema para establecer el contexto y el rol del asistente
        system_message = {
          role: 'system',
          content: <<~SYSTEM_MESSAGE
#{@chat.emoti.prompt}
          SYSTEM_MESSAGE
        }

        # Mensajes predefinidos para guiar la conversación (puedes añadirlos según sea necesario)
        predefined_messages = [
          { role: 'system', content: 'Recuerda siempre basar tus respuestas en evidencia científica y ser empático.' },
          { role: 'system', content: 'Si el usuario menciona pensamientos suicidas, proporciona recursos de emergencia y sugiere buscar ayuda inmediata.' }
        ]

        conversation_history = @chat.messages.map{|msg| {role: msg.role, content: msg.content }}

        # Combinar el mensaje del sistema, los mensajes predefinidos, el historial y el mensaje actual
        [system_message] + predefined_messages + conversation_history + [{ role: 'user', content: current_message }]
      end
      def prepare_messages_q(current_message)
        system_message = {
          role: 'system',
          content: <<~SYSTEM_MESSAGE
Tienes que a partir de las respuestas de un formulario, conseguir el emoti que mas se ajuste, los emotis entre los cuales puedes elegir son:
#{Emoti.actives.pluck(:title).join("\n")})

TU OUTPUT DEBE DE SER:
EMOTI_SELECCCIONADO
BREVE EXPLICACION DE UNA LINEA DE EL MOTIVO DE ELECCION.
NADA MAS!
          SYSTEM_MESSAGE
        }
        [system_message] + [{ role: 'user', content: current_message }]
      end
    end
  end
end
