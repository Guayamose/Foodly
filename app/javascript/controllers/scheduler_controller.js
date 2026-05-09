import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scheduler"
export default class extends Controller {
  static targets = ["searchinput", "recipeInput", "divRecipeCards",
                    "formScheduler", "aiFormScheduler", "eventList"]
  static values = { url: String }

  submit() {
    const query = this.searchinputTarget.value
    fetch(`${this.urlValue}?query=${encodeURIComponent(query)}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }

  selectRecipe(event) {
    const cards = this.divRecipeCardsTarget.querySelectorAll(".card-recipe");
    cards.forEach(element => {
      element.classList.remove("card-highlight");
    });
    event.currentTarget.classList.add("card-highlight");
    this.recipeInputTarget.value = event.currentTarget.dataset.id;
  }

  reset() {
    this.formSchedulerTarget.reset()
  }

  calendarEvent(e) {
  //   console.log(e.currentTarget)
  //  console.log(e.currentTarget.querySelectorAll('div[data-recipe]'))
  //  console.log(e.currentTarget.querySelectorAll('div[data-name]'));
    let list = '';
    this.eventListTarget.innerHTML=""
   if (e.currentTarget.querySelector('div[data-recipe]')) {
    e.currentTarget.querySelectorAll('div[data-recipe]').forEach((el)=>{
      list += `<li class="btn btn-cYellow rounded-pill"><a class="text-decoration-none text-black " href='${el.dataset.recipe}'>${el.dataset.name}</a></li>`
    });
      this.eventListTarget.innerHTML=`
         <ul class="list-unstyled d-flex flex-column gap-2 ">
          ${list}
         </ul>
      `

    }
  }
}
