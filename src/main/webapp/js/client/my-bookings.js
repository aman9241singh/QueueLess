
document.addEventListener("DOMContentLoaded", function () {
    const bookingList = document.getElementById("bookingList");
    const filters = document.querySelectorAll(".filter-btn");
    const emptyMessage = document.getElementById("emptyBookings");
    const cards = Array.from(bookingList.querySelectorAll(".booking-card"));
    let activeFilter = "all";
    function renderBookings() {
        let visibleCount = 0;
        cards.forEach(card => {
            const status = card.dataset.status;
            const show = activeFilter === "all" || status.toLowerCase() === activeFilter.toLowerCase();
            card.hidden = !show;
            if (show) visibleCount++;
        });
        emptyMessage.hidden = visibleCount > 0;
    }
    filters.forEach(button => {
        button.addEventListener("click", function () {
            activeFilter = button.dataset.filter;
            filters.forEach(item => item.classList.toggle("active", item === button));
            renderBookings();
        });
    });
    renderBookings();
});
