
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("announcementForm");
    const editorPanel = document.getElementById("editorPanel");
    const formAction = document.getElementById("formAction");
    const announcementId = document.getElementById("announcementId");
    const title = document.getElementById("announcementTitle");
    const message = document.getElementById("announcementMessage");
    const status = document.getElementById("announcementStatus");
    const editorTitle = document.getElementById("editorTitle");
    const publishBtn = document.getElementById("publishBtn");
    const toggleBtn = document.getElementById("toggleEditorBtn");
    const clearBtn = document.getElementById("clearFormBtn");
    const messageCount = document.getElementById("messageCount");
    const search = document.getElementById("announcementSearch");
    const filter = document.getElementById("announcementStatusFilter");
    const list = document.getElementById("announcementList");
    function updateCount() {
        messageCount.textContent = message.value.length + " / 1000 characters";
    }
    function clearForm() {
        form.reset();
        announcementId.value = "";
        formAction.value = "create";
        editorTitle.textContent = "Create Announcement";
        publishBtn.textContent = "Save Announcement";
        updateCount();
    }
    function filterAnnouncements() {
        const query = search.value.toLowerCase();
        const selectedStatus = filter.value;
        let visible = 0;
        list.querySelectorAll(".announcement-card").forEach(function (card) {
            const matchesText = card.textContent.toLowerCase().includes(query);
            const matchesStatus = selectedStatus === "all" || card.dataset.status === selectedStatus;
            card.style.display = matchesText && matchesStatus ? "" : "none";
            if (matchesText && matchesStatus) visible++;
        });
        const empty = document.getElementById("emptyAnnouncements");
        empty.hidden = visible !== 0;
    }
    list.querySelectorAll(".edit-announcement").forEach(function (button) {
        button.addEventListener("click", function () {
            announcementId.value = button.dataset.id;
            title.value = button.dataset.title;
            message.value = button.dataset.message;
            status.value = button.dataset.status;
            formAction.value = "update";
            editorTitle.textContent = "Edit Announcement";
            publishBtn.textContent = "Update Announcement";
            editorPanel.scrollIntoView({ behavior: "smooth" });
            updateCount();
        });
    });
    form.addEventListener("submit", function (event) {
        if (!title.value.trim() || !message.value.trim()) {
            event.preventDefault();
            alert("Please fill in all required fields.");
            return;
        }
        publishBtn.disabled = true;
        publishBtn.textContent = "Saving...";
    });
    message.addEventListener("input", updateCount);
    search.addEventListener("input", filterAnnouncements);
    filter.addEventListener("change", filterAnnouncements);
    clearBtn.addEventListener("click", clearForm);
    toggleBtn.addEventListener("click", function () {
        const hidden = editorPanel.classList.toggle("editor-hidden");
        toggleBtn.textContent = hidden ? "Show Form" : "Hide Form";
    });
    updateCount();
    filterAnnouncements();
});
