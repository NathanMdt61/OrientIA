import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "hideable"]

  call(event) {
    event.preventDefault()

    this.hideableTarget.classList.toggle("d-none")

    this.iconTargets.forEach(icon => {
      icon.classList.toggle("d-none")
    })
  }
}
