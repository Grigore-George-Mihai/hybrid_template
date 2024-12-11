// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "jquery"
import "@popperjs/core"
import "bootstrap"
import "select2"

document.addEventListener('DOMContentLoaded', () => {
	$('.select2').select2();
});
