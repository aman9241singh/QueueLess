document.addEventListener("DOMContentLoaded",function(){
    const password=document.getElementById("loginPassword");
    const toggle=document.getElementById("togglePassword");
    const forgot=document.getElementById("forgotPassword");
    const feedback=document.getElementById("loginFeedback");
    if(toggle&&password){
        toggle.addEventListener("click",function(){
            const show=password.type==="password";
            password.type=show?"text":"password";
            toggle.textContent=show?"Hide":"Show";
            toggle.setAttribute("aria-label",show?"Hide password":"Show password");
        });
    }
    if(forgot){
        forgot.addEventListener("click",function(event){
            event.preventDefault();
            if(feedback)feedback.textContent="Password recovery is not available yet.";
        });
    }
});