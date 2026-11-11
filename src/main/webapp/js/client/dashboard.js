document.addEventListener("DOMContentLoaded",function(){
    const logoutLink=document.querySelector('a[href$="/logout"]');
    if(logoutLink){
        logoutLink.addEventListener("click",function(){
            sessionStorage.removeItem("queueLessDashboard");
        });
    }
});