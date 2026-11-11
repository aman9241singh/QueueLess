
document.addEventListener("DOMContentLoaded", function () {
    const totalTokens = document.getElementById("totalTokens");
    const activeQueues = document.getElementById("activeQueues");
    const registeredUsers = document.getElementById("registeredUsers");
    const waitingCustomers = document.getElementById("waitingCustomers");
    const serviceQueueTable = document.getElementById("serviceQueueTable");

    if (totalTokens) totalTokens.textContent = "128";
    if (activeQueues) activeQueues.textContent = "4";
    if (registeredUsers) registeredUsers.textContent = "86";
    if (waitingCustomers) waitingCustomers.textContent = "12";

    if (serviceQueueTable) {
        const services = [
            { name: "Banking Services", waiting: 5, serving: 2, completed: 18 },
            { name: "Healthcare", waiting: 3, serving: 1, completed: 14 },
            { name: "Customer Support", waiting: 2, serving: 1, completed: 21 },
            { name: "Billing Counter", waiting: 2, serving: 0, completed: 11 }
        ];

        serviceQueueTable.replaceChildren();

        services.forEach(function (service) {
            const row = document.createElement("tr");

            [service.name, service.waiting, service.serving, service.completed]
                .forEach(function (value) {
                    const cell = document.createElement("td");
                    cell.textContent = value;
                    row.appendChild(cell);
                });

            serviceQueueTable.appendChild(row);
        });
    }
});
