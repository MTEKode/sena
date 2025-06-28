from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig
import torch
import intel_extension_for_pytorch as ipex

# 1. Configuración de cuantización para bajo RAM (3.5GB)
quant_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=False
)

# 2. Cargar modelo y tokenizador
model_name = "microsoft/Phi-4-mini-instruct"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    quantization_config=quant_config,
    device_map="cpu",  # Use CPU
    trust_remote_code=True
)

# Optimize the model with Intel's extension for PyTorch
model = ipex.optimize(model)

# 3. Plantilla de prompt para respuestas empáticas
SYS_PROMPT = """<|system|>Eres un asistente emocional en español. Sigue estos principios:
1. Valida siempre los sentimientos del usuario
2. Respuestas breves (<60 palabras)
3. Empatía y apoyo práctico
4. Evita juicios o consejos no solicitados</s>"""

# 4. Función para formatear diálogo
def format_prompt(messages):
    prompt = SYS_PROMPT
    for msg in messages:
        prompt += f"<|{msg['role']}|>\n{msg['content']}</s>\n"
    prompt += "<|assistant|>\n"
    return prompt

# 5. Chatbot principal
print("\n💬 [Asistente Emocional] Hola, soy tu compañero de conversación. ¿Cómo te sientes hoy? (escribe 'salir' para terminar)\n")
conversation = [{"role": "user", "content": "Por favor, preséntate brevemente"}]

while True:
    # Generar respuesta inicial
    if len(conversation) == 1:
        prompt = format_prompt(conversation)
        inputs = tokenizer(prompt, return_tensors="pt").to('cpu')
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=120,
                temperature=0.8,
                top_p=0.95,
                repetition_penalty=1.1,
                pad_token_id=tokenizer.eos_token_id
            )
        response = tokenizer.decode(outputs[0], skip_special_tokens=True)
        response = response.split("<|assistant|>")[-1].strip()
        print(f"[Asistente]: {response}\n")
        conversation.append({"role": "assistant", "content": response})

    # Interacción con el usuario
    user_input = input("Tú: ")
    if user_input.lower() in ["salir", "exit", "adiós"]:
        break
    conversation.append({"role": "user", "content": user_input})
    prompt = format_prompt(conversation)

    # Generar respuesta
    inputs = tokenizer(prompt, return_tensors="pt").to('cpu')
    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            max_new_tokens=150,
            temperature=0.85,
            top_k=40,
            top_p=0.9,
            repetition_penalty=1.15,
            pad_token_id=tokenizer.eos_token_id
        )

    # Decodificar y limpiar respuesta
    full_response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    response = full_response.split("<|assistant|>")[-1].strip()
    if "<|user|>" in response:
        response = response.split("<|user|>")[0].strip()
    print(f"\n[Asistente]: {response}\n")
    conversation.append({"role": "assistant", "content": response})

print("\n💙 Gracias por compartir tus sentimientos. Recuerda cuidarte.")
