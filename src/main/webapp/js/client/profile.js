
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("profileForm");
    const message = document.getElementById("profileMessage");
    const nameInput = document.getElementById("fullName");
    const emailInput = document.getElementById("email");
    const avatar = document.getElementById("profileAvatar");
    function updatePreview() {
        const name = nameInput.value.trim() || "Guest User";
        document.getElementById("sidebarName").textContent = name;
        document.getElementById("sidebarEmail").textContent = emailInput.value.trim() || "guest@example.com";
        avatar.textContent = name.charAt(0).toUpperCase();
    }
    nameInput.addEventListener("input", updatePreview);
    emailInput.addEventListener("input", updatePreview);
    form.addEventListener("submit", function (event) {
        event.preventDefault();
        updatePreview();
        message.textContent = "Profile preview updated successfully. Database saving will be available after backend integration.";
    });
    form.addEventListener("reset", function () {
        setTimeout(function () {
            updatePreview();
            message.textContent = "";
        }, 0);
    });
});
