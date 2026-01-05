import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        type: String,
        data: Object,
        options: Object
    }

    connect() {
        console.log("Charts controller connected");
        const canvas = this.element.querySelector('canvas');
        if (!canvas) {
            console.error("Canvas element not found");
            return;
        }
        const ctx = canvas.getContext('2d');

        if (typeof Chart === 'undefined') {
            console.error("Chart.js is not loaded");
            return;
        }

        new Chart(ctx, {
            type: this.typeValue || 'line',
            data: this.dataValue,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                ...this.optionsValue
            }
        });
    }
}
