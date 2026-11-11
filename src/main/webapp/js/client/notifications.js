
document.addEventListener("DOMContentLoaded", function () {
    const items = Array.from(document.querySelectorAll(".notification-item"));
    const filterButtons = document.querySelectorAll(".filter-btn");
    const totalCount = document.getElementById("totalCount");
    const unreadCount = document.getElementById("unreadCount");
    const emptyMessage = document.getElementById("emptyNotifications");
    let activeFilter = "all";
    function updateCounts() {
        totalCount.textContent = items.length;
        unreadCount.textContent = items.filter(function (item) {
            return item.dataset.unread === "true";
        }).length;
    }
    function applyFilter() {
        let visibleCount = 0;
        items.forEach(function (item) {
            const type = item.dataset.type;
            const isUnread = item.dataset.unread === "true";
            let matchesFilter = activeFilter === "all";
            if (activeFilter === "unread") matchesFilter = isUnread;
            if (activeFilter === "booking" || activeFilter === "announcement") matchesFilter = type === activeFilter;
            item.style.display = matchesFilter ? "" : "none";
            if (matchesFilter) visibleCount++;
        });
        emptyMessage.hidden = visibleCount !== 0;
    }
    filterButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            activeFilter = button.dataset.filter;
            filterButtons.forEach(function (btn) {
                btn.classList.toggle("active", btn === button);
            });
            applyFilter();
        });
    });
    updateCounts();
    applyFilter();
});
