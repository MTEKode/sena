require 'pycall'

# Importar el módulo transformers de Python
transformers = PyCall.import_module('transformers')

# Crear la canalización
pipe = transformers.pipeline("text2text-generation", model: "facebook/blenderbot-400M-distill")

# Definir los mensajes
messages = [
  {"role" => "user", "content" => "Who are you? Tell me something about emotions."},
]

# Formatear la conversación
input_text = ""
messages.each do |msg|
  input_text += "#{msg['role']}: #{msg['content']}\n"
end
input_text += "assistant:"

# Generar respuesta
output = pipe.call(input_text)

# Imprimir la salida
puts output
