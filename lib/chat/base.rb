require 'pycall'

PyCall.exec(<<~PYTHON)
from transformers import AutoTokenizer

model_name = "mnaylor/psychbert-cased"
tokenizer = AutoTokenizer.from_pretrained(model_name)

def tokenize_text(text):
    tokens = tokenizer.tokenize(text)
    return tokens

def analyze_text(text):
    tokens = tokenizer.tokenize(text)
    word_count = len(tokens)
    return {"tokens": tokens, "word_count": word_count}
PYTHON

def chatbot_response(input_text, analysis)
  tokens = analysis[:tokens]

  if tokens.any? { |token| token.downcase.include?("triste") }
    "Lo siento escuchar que te sientas triste. ¿Quieres hablar al respecto?"
  elsif tokens.any? { |token| token.downcase.include?("feliz") }
    "¡Me alegra escuchar que estás feliz!"
  elsif tokens.any? { |token| token.downcase.include?("enojado") }
    "Entiendo que estés enojado. ¿Hay algo en lo que pueda ayudarte?"
  elsif tokens.any? { |token| token.downcase.include?("miedo") || token.downcase.include?("asustado") }
    "El miedo es una emoción natural. ¿Hay algo específico que te dé miedo?"
  elsif tokens.any? { |token| token.downcase.include?("ansioso") || token.downcase.include?("nervioso") }
    "La ansiedad puede ser difícil. Respira profundamente y recuerda que estoy aquí para ayudarte."
  else
    "Entiendo. ¿Hay algo más en lo que pueda ayudarte?"
  end
end

def chatbot
  puts "Chatbot: Hola, ¿en qué puedo ayudarte hoy? (Escribe 'salir' para terminar)"
  loop do
    print "Tú: "
    input_text = gets.chomp
    break if input_text.downcase == 'salir'

    analysis = PyCall.eval("analyze_text(#{input_text.inspect})")
    response = chatbot_response(input_text, analysis.to_h)
    puts "Chatbot: #{response}"
  end
end

chatbot
