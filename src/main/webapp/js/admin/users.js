document.addEventListener("DOMContentLoaded", function () {
    const table = document.getElementById("usersTable");
    const search = document.getElementById("userSearch");
    const statusFilter = document.getElementById("userStatusFilter");
    const sortSelect = document.getElementById("userSort");
    const emptyState = document.getElementById("emptyUsers");
    const exportButton = document.getElementById("exportUsersBtn");
    const allRows = Array.from(table.querySelectorAll("tr[data-id]"));
    const contextPath = document.querySelector('meta[name="context-path"]').content;
    function getUserData(row) {
        return {
            name: row.querySelector(".user-name")?.textContent.trim() || "",
            email: row.querySelector(".user-email")?.textContent.trim() || "",
            phone: row.cells[1]?.textContent.trim() || "",
            joined: row.cells[2]?.textContent.trim() || "",
            tokens: row.cells[3]?.textContent.trim() || "",
            status: row.querySelector(".status-badge")?.textContent.trim() || ""
        };
    }
    function renderUsers() {
        const term = search.value.trim().toLowerCase();
        const selectedStatus = statusFilter.value;
        let visibleRows = allRows.filter(row => {
            const user = getUserData(row);
            const matchesSearch = (user.name + " " + user.email + " " + user.phone).toLowerCase().includes(term);
            const matchesStatus = selectedStatus === "all" || user.status === selectedStatus;
            return matchesSearch && matchesStatus;
        });
        if (sortSelect.value === "name") {
            visibleRows.sort((a, b) => getUserData(a).name.localeCompare(getUserData(b).name));
        } else if (sortSelect.value === "oldest") {
            visibleRows.reverse();
        }
        allRows.forEach(row => row.remove());
        visibleRows.forEach(row => table.appendChild(row));
        emptyState.hidden = visibleRows.length > 0 || allRows.length === 0;
    }
    search.addEventListener("input", renderUsers);
    statusFilter.addEventListener("change", renderUsers);
    sortSelect.addEventListener("change", renderUsers);
    table.addEventListener("click", async function (event) {
        const button = event.target.closest(".status-btn[data-id]");
        if (!button) return;
        const row = button.closest("tr");
        const currentStatus = row.dataset.status;
        const nextStatus = currentStatus === "Active" ? "Inactive" : "Active";
        if (!confirm("Are you sure you want to " + (nextStatus === "Inactive" ? "deactivate" : "activate") + " this user?")) return;
        button.disabled = true;
        try {
            const response = await fetch(contextPath + "/admin/users", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: new URLSearchParams({userId: button.dataset.id, status: nextStatus})
            });
            if (!response.ok) throw new Error("Status update failed");
            window.location.reload();
        } catch (error) {
            alert("Unable to update account status. Please try again.");
            button.disabled = false;
        }
    });
    exportButton.addEventListener("click", function () {
        const rows = [["Name", "Email", "Phone", "Joined Date", "Total Tokens", "Status"]];
        allRows.forEach(row => {
            const user = getUserData(row);
            rows.push([user.name, user.email, user.phone, user.joined, user.tokens, user.status]);
        });
        const csv = rows.map(row => row.map(value => '"' + String(value).replace(/"/g, '""') + '"').join(",")).join("\r\n");
        const blob = new Blob(["\uFEFF" + csv], {type: "text/csv;charset=utf-8;"});
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.href = url;
        link.download = "queueless-users.csv";
        link.click();
        URL.revokeObjectURL(url);
    });
    renderUsers();
});