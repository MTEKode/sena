// app/javascript/controllers/chat_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["messages", "inputField", "sendButton"];
    static values = { chatId: String };

    connect() {
        this.setupEventListeners();
        this.locked = false; // Estado para controlar si el chat está bloqueado
        window.addMessage = this.addMessage.bind(this);
    }

    setupEventListeners() {
        this.inputFieldTarget.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !this.locked) {
                this.sendMessage();
            }
        });

        this.sendButtonTarget.addEventListener('click', () => {
            if (!this.locked) {
                this.sendMessage();
            }
        });
    }

    sendMessage() {
        const messageContent = this.inputFieldTarget.value.trim();
        if (messageContent) {
            this.locked = true; // Bloquear el chat mientras se espera la respuesta
            this.inputFieldTarget.disabled = true;
            this.sendButtonTarget.disabled = true;

            this.addMessage('user', messageContent);
            this.inputFieldTarget.value = '';

            // Obtener el ID del chat
            const chatId = this.chatIdValue;

            // Enviar mensaje al servidor usando fetch
            fetch('/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    chat: { id: chatId },
                    message: { content: messageContent }
                })
            })
                .then(response => response.json())
                .then(data => {
                    // Agregar la respuesta del bot al chat
                    window.addMessage('bot', data.message);
                })
                .catch(error => {
                    console.error('Error:', error);
                    window.addMessage('bot', 'Lo siento, hubo un error al procesar tu mensaje.');
                })
                .finally(() => {
                    // Desbloquear el chat después de recibir la respuesta o un error
                    this.locked = false;
                    this.inputFieldTarget.disabled = false;
                    this.sendButtonTarget.disabled = false;
                });
        }
    }

    addMessage(sender, text) {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', sender);
        messageDiv.textContent = text;
        this.messagesTarget.appendChild(messageDiv);
        this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    }

    get chatIdValue() {
        return document.getElementById('chat-id').value;
    }
}
