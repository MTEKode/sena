import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.initializeEmotiWelcomeTalking();
  }

  initializeEmotiWelcomeTalking() {
    const typewriter = new Typewriter('.welcome-info-text p', {
      delay: 30,
      cursor: ''
    })
      .typeString('Hola, haz click en mi si quieres seguir con tu ultima sesion?');

    setTimeout(() => {
      typewriter.start()
    })
  }
}

