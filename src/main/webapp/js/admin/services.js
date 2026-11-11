
document.addEventListener("DOMContentLoaded",function(){
    const form=document.getElementById("serviceForm");
    const table=document.getElementById("servicesTable");
    const search=document.getElementById("serviceSearch");
    const filter=document.getElementById("statusFilter");
    const panel=document.getElementById("serviceFormPanel");
    const toggleFormBtn=document.getElementById("toggleFormBtn");
    const emptyState=document.getElementById("emptyState");
    const serviceId=document.getElementById("serviceId");
    const action=document.getElementById("action");
    function clearForm(){
        form.reset();
        serviceId.value="";
        action.value="add";
        document.getElementById("formTitle").textContent="Add New Service";
        document.getElementById("saveServiceBtn").textContent="Add Service";
    }
    function filterServices(){
        const term=search.value.trim().toLowerCase();
        const status=filter.value;
        let visible=0;
        Array.from(table.querySelectorAll("tr")).forEach(row=>{
            const text=row.textContent.toLowerCase();
            const badge=row.querySelector(".status-badge");
            const rowStatus=badge?badge.textContent.trim().toLowerCase():"";
            const matchesSearch=text.includes(term);
            const matchesStatus=status==="all"||rowStatus===status;
            const show=matchesSearch&&matchesStatus;
            row.hidden=!show;
            if(show) visible++;
        });
        emptyState.hidden=visible>0;
        document.getElementById("serviceCount").textContent=visible+" service"+(visible===1?"":"s");
    }
    form.addEventListener("submit",function(){
        action.value=serviceId.value?"update":"add";
    });
    table.addEventListener("click",function(event){
        const button=event.target.closest(".edit-btn");
        if(!button) return;
        serviceId.value=button.dataset.id;
        document.getElementById("serviceName").value=button.dataset.name;
        document.getElementById("serviceCategory").value=button.dataset.category;
        document.getElementById("serviceLocation").value=button.dataset.location;
        document.getElementById("serviceWait").value=button.dataset.wait;
        document.getElementById("serviceDescription").value=button.dataset.description;
        action.value="update";
        document.getElementById("formTitle").textContent="Edit Service";
        document.getElementById("saveServiceBtn").textContent="Save Changes";
        form.hidden=false;
        toggleFormBtn.textContent="Hide Form";
        panel.scrollIntoView({behavior:"smooth",block:"start"});
    });
    search.addEventListener("input",filterServices);
    filter.addEventListener("change",filterServices);
    toggleFormBtn.addEventListener("click",function(){
        form.hidden=!form.hidden;
        toggleFormBtn.textContent=form.hidden?"Show Form":"Hide Form";
    });
    document.getElementById("cancelEditBtn").addEventListener("click",clearForm);
    filterServices();
});
