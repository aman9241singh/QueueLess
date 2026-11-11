
document.addEventListener("DOMContentLoaded", function () {
    const tokenSearch = document.getElementById("tokenSearch");
    const searchButton = document.getElementById("searchButton");
    const showAllButton = document.getElementById("showAllButton");
    const bookingList = document.getElementById("bookingList");
    const emptyMessage = document.getElementById("emptyMessage");
    const queueMessage = document.getElementById("queueMessage");
    const endpoint = bookingList.dataset.endpoint;
    let bookingCards = [];
    let refreshing = false;

    function addDetail(container, label, value) {
        const item = document.createElement("div");
        const title = document.createElement("span");
        const detail = document.createElement("strong");
        title.textContent = label;
        detail.textContent = value;
        item.append(title, detail);
        container.appendChild(item);
    }

    function formatDate(value) {
        if (!value) return "Not specified";
        const parts = value.split("-");
        if (parts.length !== 3) return value;
        const date = new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
        return date.toLocaleDateString("en-IN", {day: "2-digit", month: "short", year: "numeric"});
    }

    function formatTime(value) {
        if (!value) return "Not specified";
        const parts = value.split(":");
        if (parts.length < 2) return value;
        const date = new Date();
        date.setHours(Number(parts[0]), Number(parts[1]), 0, 0);
        return date.toLocaleTimeString("en-IN", {hour: "2-digit", minute: "2-digit", hour12: true});
    }

    function createCard(item) {
        const token = item.tokenNumber || "Not assigned";
        const status = item.queueStatus || item.bookingStatus || "Waiting";
        const card = document.createElement("article");
        card.className = "booking-card";
        card.dataset.token = token.toLowerCase();
        card.dataset.status = status.toLowerCase();

        const top = document.createElement("div");
        top.className = "booking-card-top";
        const tokenInfo = document.createElement("div");
        const label = document.createElement("span");
        label.className = "booking-label";
        label.textContent = "TOKEN NUMBER";
        const heading = document.createElement("h2");
        heading.textContent = token;
        tokenInfo.append(label, heading);

        const badge = document.createElement("span");
        badge.className = "booking-status " + status.toLowerCase();
        badge.textContent = status;
        top.append(tokenInfo, badge);

        const details = document.createElement("div");
        details.className = "booking-details";
        addDetail(details, "Service", item.serviceName || "Not specified");
        addDetail(details, "Visit Date", formatDate(item.visitDate));
        addDetail(details, "Preferred Time", formatTime(item.preferredTime));
        addDetail(details, "Queue Position", item.queuePosition ?? "N/A");
        addDetail(details, "Estimated Waiting Time", item.estimatedWait == null ? "N/A" : item.estimatedWait + " minutes");
        addDetail(details, "Currently Serving", item.currentServing || "Not started");

        card.append(top, details);
        return card;
    }

    function filterBookings() {
        const searchValue = tokenSearch.value.trim().toLowerCase();
        let visibleCount = 0;

        bookingCards.forEach(function (card) {
            const matches = (card.dataset.token || "").includes(searchValue);
            card.hidden = !matches;
            if (matches) visibleCount++;
        });

        emptyMessage.hidden = visibleCount !== 0;
        queueMessage.textContent = visibleCount === 0 ? "No matching token found." : visibleCount + " booking(s) found.";
    }

    async function refreshQueue() {
        if (refreshing) return;
        refreshing = true;

        try {
            const response = await fetch(endpoint, {cache: "no-store"});
            if (response.status === 401) {
                window.location.href = document.querySelector(".btn-login").href;
                return;
            }
            if (!response.ok) throw new Error("Unable to refresh queue.");
            const data = await response.json();

            const cards = data.map(createCard);
            bookingList.replaceChildren(...cards);
            bookingCards = Array.from(bookingList.querySelectorAll(".booking-card"));
            filterBookings();
        } catch (error) {
            queueMessage.textContent = "Unable to refresh queue. Please check your connection.";
        } finally {
            refreshing = false;
        }
    }

    searchButton.addEventListener("click", filterBookings);

    tokenSearch.addEventListener("keydown", function (event) {
        if (event.key === "Enter") filterBookings();
    });

    showAllButton.addEventListener("click", function () {
        tokenSearch.value = "";
        filterBookings();
    });

    refreshQueue();
    setInterval(refreshQueue, 10000);
});
