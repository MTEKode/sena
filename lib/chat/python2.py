from llama_cpp import Llama
import os

# Configuración del modelo (Q4_K_M = mejor calidad/rendimiento)
MODEL_URL = "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
MODEL_NAME = "tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"

# Descargar modelo si no existe (~600 MB)
if not os.path.exists(MODEL_NAME):
    print("Descargando modelo... (por favor espere)")
    import requests
    response = requests.get(MODEL_URL)
    with open(MODEL_NAME, 'wb') as f:
        f.write(response.content)

# Cargar modelo (usa solo ~1.5 GB RAM)
llm = Llama(
    model_path=MODEL_NAME,
    n_ctx=1024,      # Contexto reducido para ahorrar RAM
    n_threads=4,     # Usa 4 hilos de CPU
    n_gpu_layers=0,  # 0 = solo CPU
    verbose=False
)

# Plantilla para respuestas empáticas
SYS_PROMPT = """[INST] <<SYS>>
Eres un asistente emocional que responde en español. Sé empático, comprensivo y ofrece apoyo emocional.
Valida siempre los sentimientos del usuario y responde brevemente (<70 palabras).
<</SYS>>"""

def format_prompt(user_input):
    return f"{SYS_PROMPT}\n\nUsuario: {user_input} [/INST] Asistente:"

print("\n[Bot Emocional] Hola, soy tu acompañante emocional. ¿Cómo te sientes hoy? (escribe 'salir' para terminar)\n")

while True:
    user_input = input("Tú: ")
    if user_input.lower() == "salir":
        break

    # Generar respuesta
    prompt = format_prompt(user_input)
    output = llm(
        prompt,
        max_tokens=100,    # Respuestas cortas
        temperature=0.8,    # Más creatividad
        stop=["[/INST]", "Usuario:", "\n\n"],
        echo=False
    )

    # Mostrar respuesta limpia
    response = output['choices'][0]['text'].strip()
    print(f"\n[Asistente]: {response}\n")

print("\n💚 Cuídate y gracias por compartir tus sentimientos.")