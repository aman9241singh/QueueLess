
const form = document.getElementById("settingsForm");
const toast = document.getElementById("settingsToast");
const maintenance = document.getElementById("maintenanceMode");
const maintenanceMessage = document.getElementById("maintenanceMessage");
const resetButton = document.getElementById("resetSettings");
const initialValues = {};
Array.from(form.elements).forEach(element => {
    if (element.id) initialValues[element.id] = element.type === "checkbox" ? element.checked : element.value;
});
function showToast(message) {
    toast.textContent = message;
    toast.classList.add("show");
    setTimeout(() => toast.classList.remove("show"), 2800);
}
function updateMaintenance() {
    maintenanceMessage.classList.toggle("hidden", !maintenance.checked);
}
maintenance.addEventListener("change", updateMaintenance);
resetButton.addEventListener("click", () => {
    Object.entries(initialValues).forEach(([id, value]) => {
        const element = document.getElementById(id);
        if (element) {
            if (element.type === "checkbox") element.checked = value;
            else element.value = value;
        }
    });
    updateMaintenance();
    showToast("Form restored to its loaded values.");
});
updateMaintenance();
