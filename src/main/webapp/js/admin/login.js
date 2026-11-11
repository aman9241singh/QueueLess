
document.addEventListener("DOMContentLoaded", function () {
    const password = document.getElementById("adminPassword");
    const toggle = document.getElementById("togglePassword");
    if (toggle && password) {
        toggle.addEventListener("click", function () {
            const show = password.type === "password";
            password.type = show ? "text" : "password";
            toggle.textContent = show ? "Hide" : "Show";
            toggle.setAttribute("aria-label", show ? "Hide password" : "Show password");
        });
    }
});
