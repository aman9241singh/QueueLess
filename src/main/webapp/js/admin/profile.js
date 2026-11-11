
const profileForm = document.getElementById("profileForm");
const passwordForm = document.getElementById("passwordForm");
const toast = document.getElementById("profileToast");
const fullName = document.getElementById("fullName");
const email = document.getElementById("email");
function showToast(message) {
    toast.textContent = message;
    toast.classList.add("show");
    clearTimeout(showToast.timer);
    showToast.timer = setTimeout(() => toast.classList.remove("show"), 2800);
}
profileForm.addEventListener("submit", event => {
    if (!profileForm.reportValidity()) {
        event.preventDefault();
        return;
    }
});
passwordForm.addEventListener("submit", event => {
    if (!passwordForm.reportValidity()) {
        event.preventDefault();
        return;
    }
    const current = document.getElementById("currentPassword").value;
    const next = document.getElementById("newPassword").value;
    const confirm = document.getElementById("confirmPassword").value;
    if (next !== confirm) {
        event.preventDefault();
        document.getElementById("confirmPassword").setCustomValidity("Passwords do not match.");
        passwordForm.reportValidity();
        return;
    }
    document.getElementById("confirmPassword").setCustomValidity("");
    if (current === next) {
        event.preventDefault();
        showToast("New password must differ from the current password.");
    }
});
document.getElementById("confirmPassword").addEventListener("input", event => event.target.setCustomValidity(""));
