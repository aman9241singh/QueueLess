
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("bookingForm");
    const nameInput = document.getElementById("fullName");
    const emailInput = document.getElementById("email");
    const phoneInput = document.getElementById("phone");
    const dateInput = document.getElementById("date");
    const message = document.getElementById("bookingMessage");
    const result = document.getElementById("tokenResult");

    function getToday() {
        const today = new Date();
        return [
            today.getFullYear(),
            String(today.getMonth() + 1).padStart(2, "0"),
            String(today.getDate()).padStart(2, "0")
        ].join("-");
    }

    dateInput.min = getToday();

    nameInput.addEventListener("input", function () {
        nameInput.setCustomValidity("");
    });

    emailInput.addEventListener("input", function () {
        emailInput.setCustomValidity("");
    });

    phoneInput.addEventListener("input", function () {
        phoneInput.value = phoneInput.value.replace(/\D/g, "").slice(0, 10);
        phoneInput.setCustomValidity("");
    });

    dateInput.addEventListener("change", function () {
        dateInput.setCustomValidity("");
    });

    form.addEventListener("submit", function (event) {
        message.textContent = "";
        result.hidden = true;

        const name = nameInput.value.trim();
        const email = emailInput.value.trim();
        const phone = phoneInput.value.trim();

        nameInput.value = name;
        emailInput.value = email;

        nameInput.setCustomValidity(
            name.length < 2 ? "Please enter your full name." : ""
        );

        emailInput.setCustomValidity(
            emailInput.validity.typeMismatch
                ? "Please enter a valid email address."
                : ""
        );

        phoneInput.setCustomValidity(
            !/^[0-9]{10}$/.test(phone)
                ? "Please enter a valid 10-digit phone number."
                : ""
        );

        dateInput.setCustomValidity(
            dateInput.value && dateInput.value < getToday()
                ? "Please select today or a future date."
                : ""
        );

        if (!form.checkValidity()) {
            event.preventDefault();
            form.reportValidity();
        }
    });
});
