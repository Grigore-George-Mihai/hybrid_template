import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.hideFlashAfterDelay();
  }

  hideFlashAfterDelay() {
    setTimeout(() => {
      this.element.style.opacity = '0';
      setTimeout(() => {
        if (this.element.parentNode) {
          this.element.parentNode.removeChild(this.element);
        }
      }, 500);
    }, 3000);
  }
}
