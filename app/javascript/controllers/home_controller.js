import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.initializeGlide();
    }

    initializeGlide() {
        const chrGlide = new Glide(this.element.querySelector('.characters-glide'), {
            type: 'carousel',
            startAt: 0,
            perView: 3,
            gap: 20,
            autoplay: 5000, // Auto-reproducción cada 5 segundos
            hoverpause: true, // Pausa al pasar el ratón
            breakpoints: {
                768: {
                    perView: 2, // Mostrar un elemento en pantallas más pequeñas
                    gap: 10
                }
            }
        });

        chrGlide.mount();
    }
}
