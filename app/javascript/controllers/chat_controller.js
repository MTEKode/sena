// app/javascript/controllers/chat_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["messages", "inputField", "sendButton"];
    static values = {
        chatId: String,
        emotiImgUrl: String
    };

    connect() {
        this.setupEventListeners();
        this.locked = false; // Estado para controlar si el chat está bloqueado
        window.addMessage = this.addMessage.bind(this);
        this.scrollToBottom();
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

            // Enviar mensaje al servidor usando fetch
            fetch('/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    chat: { id: this.chatIdValue },
                    message: { content: messageContent }
                })
            })
                .then(response => response.json())
                .then(data => {
                    // Agregar la respuesta del bot al chat
                    this.addMessage('assistant', data.message);
                })
                .catch(error => {
                    console.error('Error:', error);
                    this.addMessage('assistant', 'Lo siento, hubo un error al procesar tu mensaje.');
                })
                .finally(() => {
                    // Desbloquear el chat después de recibir la respuesta o un error
                    this.locked = false;
                    this.inputFieldTarget.disabled = false;
                    this.sendButtonTarget.disabled = false;
                });
        }
    }

    addMessage(role, text) {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', role);

        if (role === 'assistant') {
            const emotiImage = document.createElement('img');
            emotiImage.src = this.emotiImgUrlValue;
            emotiImage.alt = 'Emoti';
            messageDiv.appendChild(emotiImage);
        }

        const msgContentWrap = document.createElement('div');
        msgContentWrap.classList.add('msg-content-wrap');

        const msgContent = document.createElement('div');
        msgContent.classList.add('msg-content');
        msgContent.innerHTML = text;

        const timestamp = document.createElement('div');
        timestamp.classList.add('timestamp');
        timestamp.textContent = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

        msgContentWrap.appendChild(msgContent);
        msgContentWrap.appendChild(timestamp);

        messageDiv.appendChild(msgContentWrap);

        this.messagesTarget.appendChild(messageDiv);
        this.scrollToBottom();
    }

    scrollToBottom() {
        // Desplazar el contenedor de mensajes hacia abajo
        this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    }
}
