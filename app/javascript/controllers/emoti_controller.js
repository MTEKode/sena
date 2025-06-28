import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.initializeGlide();
    }

    initializeGlide() {
        const emotisGlide = new Glide(this.element.querySelector('.emotis-glide'), {
            type: 'carousel',
            focusAt: '1',
            perView: 1
        });

        emotisGlide.mount();
    }
}
