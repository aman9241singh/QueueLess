document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("contactForm");
    if (!form) return;
    const button = form.querySelector('button[type="submit"]');
    form.addEventListener("submit", function () {
        button.disabled = true;
        button.textContent = "Sending...";
    });
});