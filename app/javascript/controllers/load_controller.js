import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="load"
export default class extends Controller {
  static targets = ["spinner"]

  addLoad() {
    this.spinnerTarget.classList.remove("d-none")
  }
}
