import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  fill(event) {
    const question = event.currentTarget.textContent.trim()
    const input = document.querySelector(".input-chat")
    if (input) input.value = question
  }
}
