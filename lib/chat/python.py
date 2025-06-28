from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
import os

# 1. Configuración óptima para CPU
os.environ["OMP_NUM_THREADS"] = "4"
os.environ["TOKENIZERS_PARALLELISM"] = "false"
torch.set_num_threads(4)

# 2. Configuración de cuantización INT4
model_name = "microsoft/Phi-3-mini-128k-instruct"

# 3. Cargar tokenizer y modelo con cuantización INT4
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)

# 4. Cargar modelo con cuantización optimizada para CPU
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    device_map="auto",
    trust_remote_code=True,
    torch_dtype=torch.bfloat16,
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16
)

# 5. Solución específica para el error de caché en Phi-3
def fix_cache_issue(model):
    if hasattr(model.config, "sliding_window") and model.config.sliding_window is not None:
        # Deshabilitar ventana deslizante para evitar errores
        model.config.sliding_window = None
    return model

model = fix_cache_issue(model)

# 6. Plantilla de prompt específica para Phi-3
SYS_PROMPT = """<|system|>
Eres un asistente emocional en español. Sigue estos principios:
1. Valida siempre los sentimientos del usuario
2. Respuestas breves (<60 palabras)
3. Empatía y apoyo práctico
4. Evita juicios o consejos no solicitados<|end|>
"""

def format_prompt(messages):
    prompt = SYS_PROMPT
    for msg in messages:
        role = "user" if msg["role"] == "user" else "assistant"
        prompt += f"<|{role}|>\n{msg['content']}<|end|>\n"
    prompt += "<|assistant|>\n"
    return prompt

# 7. Función optimizada para generación
def generate_response(prompt, max_tokens=150):
    inputs = tokenizer(
        prompt,
        return_tensors="pt",
        padding=True,
        truncation=True,
        max_length=1024
    ).to(model.device)

    # Configuración de generación compatible con Phi-3
    generation_config = {
        "max_new_tokens": max_tokens,
        "temperature": 0.7,
        "top_p": 0.9,
        "repetition_penalty": 1.1,
        "pad_token_id": tokenizer.eos_token_id,
        "do_sample": True,
        "num_beams": 1,  # Usar greedy decoding para ahorrar RAM
    }

    # Solución alternativa para el error de caché
    with torch.no_grad():
        outputs = model.generate(
            **inputs,
            **generation_config,
            use_cache=False  # Desactivar caché para evitar el error
        )

    response = tokenizer.decode(outputs[0], skip_special_tokens=False)

    # Extraer solo la respuesta del asistente
    start_tag = "<|assistant|>"
    end_tag = "<|end|>"
    start_idx = response.rfind(start_tag)
    if start_idx != -1:
        response = response[start_idx + len(start_tag):]
        end_idx = response.find(end_tag)
        if end_idx != -1:
            response = response[:end_idx].strip()

    # Eliminar cualquier token restante
    response = response.replace("<|end|>", "").replace("<|assistant|>", "").strip()

    return response

# 8. Chatbot principal
print("\n💬 [Asistente Emocional Phi-3] Hola, soy tu compañero de conversación. ¿Cómo te sientes hoy? (escribe 'salir' para terminar)\n")

conversation = [{"role": "user", "content": "Por favor, preséntate brevemente"}]

# Generar respuesta inicial
print("Generando respuesta inicial... (puede tomar unos segundos)")
prompt = format_prompt(conversation)
response = generate_response(prompt, max_tokens=100)
print(f"[Asistente]: {response}")
conversation.append({"role": "assistant", "content": response})

# Bucle de conversación
while True:
    try:
        user_input = input("\nTú: ")
        if user_input.lower() in ["salir", "exit", "adiós"]:
            break

        conversation.append({"role": "user", "content": user_input})
        prompt = format_prompt(conversation)

        # Generar respuesta
        response = generate_response(prompt)

        print(f"\n[Asistente]: {response}")
        conversation.append({"role": "assistant", "content": response})

        # Limitar historial de conversación para ahorrar memoria
        if len(conversation) > 4:
            conversation = conversation[-4:]

    except KeyboardInterrupt:
        break
    except Exception as e:
        print(f"\n⚠️ Error: {str(e)}")
        print("Reiniciando conversación...\n")
        # Mantener solo el primer mensaje
        conversation = conversation[:1] if conversation else [
            {"role": "user", "content": "Por favor, preséntate brevemente"}
        ]
        # Liberar memoria
        torch.cuda.empty_cache() if torch.cuda.is_available() else None

print("\n💙 Gracias por compartir tus sentimientos. Recuerda cuidarte.")