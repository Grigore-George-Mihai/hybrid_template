import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["link"];

	connect() {
		const currentPath = window.location.pathname;

		this.linkTargets.forEach((link) => {
			if (link.getAttribute("href") === currentPath) {
				link.classList.add("active");
			}
		});
	}
}
