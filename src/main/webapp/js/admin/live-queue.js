document.addEventListener("DOMContentLoaded", function () {
    const queueTable = document.getElementById("queueTable");
    const queueSearch = document.getElementById("queueSearch");
    const serviceFilter = document.getElementById("serviceFilter");
    const statusFilter = document.getElementById("queueStatusFilter");
    const refreshQueueBtn = document.getElementById("refreshQueueBtn");
    const emptyQueue = document.getElementById("emptyQueue");
    const queueMessage = document.getElementById("queueMessage");
    const contextPath = document.body.dataset.contextPath;
    function filterQueue() {
        const search = queueSearch.value.trim().toLowerCase();
        const service = serviceFilter.value;
        const status = statusFilter.value;
        let visibleCount = 0;
        queueTable.querySelectorAll("tr").forEach(row => {
            const matchesSearch = row.dataset.token.toLowerCase().includes(search) || row.dataset.customer.toLowerCase().includes(search);
            const matchesService = service === "all" || row.dataset.service === service;
            const matchesStatus = status === "all" || row.dataset.status === status;
            const visible = matchesSearch && matchesService && matchesStatus;
            row.hidden = !visible;
            if (visible) visibleCount++;
        });
        emptyQueue.hidden = visibleCount > 0;
    }
    async function updateStatus(queueId, status, button) {
        button.disabled = true;
        queueMessage.textContent = "Updating queue status...";
        try {
            const response = await fetch(contextPath + "/admin/update-queue-status", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams({
                    queueId: queueId,
                    status: status
                })
            });
            if (!response.ok) {
                throw new Error(await response.text() || "Unable to update queue status.");
            }
            queueMessage.textContent = "Queue status updated successfully.";
            window.location.href = contextPath + "/admin/live-queue";
        } catch (error) {
            queueMessage.textContent = error.message;
            button.disabled = false;
        }
    }
    queueTable.addEventListener("click", function (event) {
        const button = event.target.closest("button");
        if (!button) return;
        const row = button.closest("tr");
        if (!row) return;
        if (button.classList.contains("serve-btn")) {
            updateStatus(row.dataset.queueId, "Serving", button);
        } else if (button.classList.contains("complete-btn")) {
            updateStatus(row.dataset.queueId, "Completed", button);
        }
    });
    queueSearch.addEventListener("input", filterQueue);
    serviceFilter.addEventListener("change", filterQueue);
    statusFilter.addEventListener("change", filterQueue);
    refreshQueueBtn.addEventListener("click", function () {
        window.location.href = contextPath + "/admin/live-queue";
    });
    filterQueue();
});