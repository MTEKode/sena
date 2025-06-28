module ChatApi
  module Gpt
    class EmotiSelectorClient < Client

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
          content: <<~SYSTEM_MESSAGE
            Tienes que a partir de las respuestas de un formulario, conseguir el emoti que mas se ajuste, los emotis entre los cuales puedes elegir son:
            #{Emoti.actives.pluck(:key, :title).to_h}
            TU OUTPUT DEBE DE SER UN JSON:
            {
              emoti_selected: PRIMER PARAMETRO DE LOS EMOTES A ELEGIR(QUE ES LA KEY, ESTA EN MINUSCULAS),
              description: BREVE EXPLICACION DE UNA LINEA AL USUARIO(Ejemplo: Este Emoti encaja bien contigo porque... etc(Mejora esta explicacion pero enfocala como diciendoselo al usuario.))
            }
            NADA MAS!
          SYSTEM_MESSAGE
        }
        [system_message] + [{ role: 'user', content: current_message }]
      end
    end
  end
end
