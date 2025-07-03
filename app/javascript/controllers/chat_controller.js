// app/javascript/controllers/chat_controller.js
import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["messages", "inputField", "sendButton"];
  static values = {
    chatId: String,
    emotiImgUrl: String
  };

  connect() {
    this.setupEventListeners();
    this.locked = false;
    this.isTyping = false;
    this.scrollInterval = null;
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
      this.locked = true;
      this.inputFieldTarget.disabled = true;
      this.sendButtonTarget.disabled = true;

      this.addMessage('user', messageContent);
      this.inputFieldTarget.value = '';

      fetch('/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          chat: {id: this.chatIdValue},
          message: {content: messageContent}
        })
      })
        .then(response => response.json())
        .then(data => {
          this.addMessage('assistant', data.message);
        })
        .catch(error => {
          console.error('Error:', error);
          this.addMessage('assistant', 'Lo siento, hubo un error al procesar tu mensaje.');
        })
        .finally(() => {
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

    if (role === 'assistant') {
      this.isTyping = true;
      this.startTypingScroll(); // Iniciar el scroll automático al empezar a escribir

      new Typewriter(msgContent, {
        delay: 30,
        cursor: ''
      })
        .typeString(text)
        .callFunction(() => {
          this.isTyping = false;
          this.stopTypingScroll(); // Detener el scroll automático al terminar de escribir
          this.scrollToBottom(); // Un último scroll para asegurar posición final
        })
        .start();
    } else {
      msgContent.textContent = text;
    }

    const timestamp = document.createElement('div');
    timestamp.classList.add('timestamp');
    timestamp.textContent = new Date().toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});

    msgContentWrap.appendChild(msgContent);
    msgContentWrap.appendChild(timestamp);

    messageDiv.appendChild(msgContentWrap);

    this.messagesTarget.appendChild(messageDiv);
    this.scrollToBottom();
  }

  startTypingScroll() {
    // Si ya hay un intervalo activo, no crear otro
    if (this.scrollInterval) return;

    // Configurar el scroll suave
    this.messagesTarget.style.scrollBehavior = 'smooth';

    // Crear intervalo para scroll automático
    this.scrollInterval = setInterval(() => {
      if (this.isTyping) {
        this.scrollToBottom();
      }
    }, 100); // Intervalo reducido para mejor rendimiento
  }

  stopTypingScroll() {
    // Limpiar el intervalo si existe
    if (this.scrollInterval) {
      clearInterval(this.scrollInterval);
      this.scrollInterval = null;
    }

    // Restaurar el scroll behavior a auto (instantáneo) para otras acciones
    setTimeout(() => {
      this.messagesTarget.style.scrollBehavior = 'auto';
    }, 500);
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}