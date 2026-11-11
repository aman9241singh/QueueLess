
let charts = {};
let currentData = null;
const contextPath = document.querySelector('meta[name="context-path"]').content;
const colors = ['#2563eb','#16a34a','#f59e0b','#dc2626','#8b5cf6','#0891b2','#ea580c'];
async function loadAnalytics(days = 7) {
    try {
        const response = await fetch(`${contextPath}/admin/analytics?format=json&days=${days}`);
        if (!response.ok) throw new Error('Unable to load analytics data.');
        currentData = await response.json();
        updateSummary(currentData.summary);
        drawCharts(currentData);
        updatePerformanceTable(currentData.servicePerformance);
    } catch (error) {
        console.error(error);
        alert('Unable to load analytics. Please refresh the page.');
    }
}
function updateSummary(summary) {
    document.getElementById('totalTokens').textContent = Number(summary.totalTokens || 0).toLocaleString();
    document.getElementById('completionRate').textContent = `${summary.completionRate || 0}%`;
    document.getElementById('averageWait').textContent = `${summary.averageWait || 0} min`;
    document.getElementById('activeServices').textContent = summary.activeServices || 0;
}
function createChart(id, config) {
    if (charts[id]) charts[id].destroy();
    const canvas = document.getElementById(id);
    charts[id] = new Chart(canvas, config);
}
function drawCharts(data) {
    const bookingDates = getDateLabels(Number(document.getElementById('reportPeriod').value));
    const bookingValues = bookingDates.map(date => data.bookingTrends[date] || 0);
    const completedValues = bookingDates.map(date => data.completedTrends[date] || 0);
    createChart('tokenChart', {
        type: 'line',
        data: {
            labels: bookingDates.map(formatDate),
            datasets: [
                {label:'Bookings',data:bookingValues,borderColor:'#2563eb',backgroundColor:'rgba(37,99,235,0.12)',fill:true,tension:0.35},
                {label:'Completed',data:completedValues,borderColor:'#16a34a',backgroundColor:'rgba(22,163,74,0.10)',fill:true,tension:0.35}
            ]
        },
        options: {responsive:true,maintainAspectRatio:false,plugins:{legend:{position:'bottom'}},scales:{y:{beginAtZero:true,ticks:{precision:0}}}}
    });
    const statusLabels = ['Waiting','Serving','Completed','Cancelled'];
    const statusValues = statusLabels.map(status => data.statusDistribution[status] || 0);
    createChart('statusChart', {
        type:'doughnut',
        data:{labels:statusLabels,datasets:[{data:statusValues,backgroundColor:['#f59e0b','#2563eb','#16a34a','#dc2626'],borderWidth:2}]},
        options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{position:'bottom'}}}
    });
    const services = data.servicePerformance || [];
    createChart('serviceChart', {
        type:'bar',
        data:{labels:services.map(item=>item.serviceName),datasets:[{label:'Bookings',data:services.map(item=>item.total),backgroundColor:colors,borderRadius:6}]},
        options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,ticks:{precision:0}}}}
    });
    const weekDays = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    createChart('trafficChart', {
        type:'bar',
        data:{labels:weekDays,datasets:[{label:'Bookings',data:weekDays.map(day=>data.weeklyTraffic[day]||0),backgroundColor:'#0d9488',borderRadius:6}]},
        options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,ticks:{precision:0}}}}
    });
}
function updatePerformanceTable(services) {
    const tbody = document.getElementById('performanceTable');
    if (!services || services.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5">No service data available for this period.</td></tr>';
        return;
    }
    tbody.innerHTML = services.map(service => {
        const total = Number(service.total || 0);
        const completed = Number(service.completed || 0);
        const rate = total === 0 ? 0 : Math.round(completed * 100 / total);
        return `<tr><td>${escapeHtml(service.serviceName)}</td><td>${total}</td><td>${completed}</td><td>${service.averageWait} min</td><td>${rate}%</td></tr>`;
    }).join('');
}
function getDateLabels(days) {
    const dates = [];
    const today = new Date();
    for (let i = days - 1; i >= 0; i--) {
        const date = new Date(today);
        date.setDate(today.getDate() - i);
        dates.push(`${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}`);
    }
    return dates;
}
function formatDate(date) {
    const parts = date.split('-');
    return `${parts[2]}/${parts[1]}`;
}
function escapeHtml(value) {
    return String(value).replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
}
document.getElementById('reportPeriod').addEventListener('change', function() {
    loadAnalytics(Number(this.value));
});
document.getElementById('downloadReport').addEventListener('click', function() {
    if (!currentData) return;
    const rows = [['Service','Total Bookings','Completed','Average Wait','Completion Rate']];
    currentData.servicePerformance.forEach(service => {
        const total = Number(service.total || 0);
        const completed = Number(service.completed || 0);
        const rate = total === 0 ? 0 : Math.round(completed * 100 / total);
        rows.push([service.serviceName,total,completed,service.averageWait,`${rate}%`]);
    });
    const csv = rows.map(row=>row.map(value=>`"${String(value).replace(/"/g,'""')}"`).join(',')).join('\n');
    const blob = new Blob([csv],{type:'text/csv;charset=utf-8;'});
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'QueueLess_Analytics_Report.csv';
    link.click();
    URL.revokeObjectURL(url);
});
loadAnalytics(Number(document.getElementById('reportPeriod').value));
