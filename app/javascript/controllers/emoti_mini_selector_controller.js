import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["list"]; // Añade un target para la lista

    connect() {
        this.setupEmotis();
    }

    setupEmotis() {
        fetch('/emoti.json', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
        })
            .then(response => {
                if (!response.ok) throw new Error("Network response was not ok");
                return response.json();
            })
            .then(data => {
                this.renderEmotis(data); // Llama a la función para renderizar los emotis
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    renderEmotis(emotis) {
        // Limpia la lista primero
        this.listTarget.innerHTML = '';

        // Crea elementos para cada emoti
        emotis.forEach(emoti => {
            const emotiElement = this.createEmotiElement(emoti);
            this.listTarget.appendChild(emotiElement);
        });
    }

    createEmotiElement(emoti) {
        // Crea un elemento HTML para cada emoti
        const li = document.createElement('li');

        // Aquí puedes personalizar cómo se muestra cada emoti
        // Por ejemplo, si el emoti tiene un nombre y una imagen:
        li.innerHTML = `
          <a href="${emoti.chat_link}">
            <img src="${emoti.image_url}" alt="${emoti.name}" width="40" height="40">
          </a>
        `;

        // Añade clases CSS si es necesario
        li.classList.add('emoti-item');

        return li;
    }
}