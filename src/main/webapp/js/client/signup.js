
document.addEventListener("DOMContentLoaded",function(){
    const form=document.getElementById("signupForm");
    const password=document.getElementById("signupPassword");
    const confirmPassword=document.getElementById("confirmPassword");
    if(!form||!password||!confirmPassword)return;
    function validatePassword(){
        if(confirmPassword.value&&password.value!==confirmPassword.value){
            confirmPassword.setCustomValidity("Passwords do not match.");
            return false;
        }
        confirmPassword.setCustomValidity("");
        return true;
    }
    password.addEventListener("input",validatePassword);
    confirmPassword.addEventListener("input",validatePassword);
    form.addEventListener("submit",function(event){
        if(!validatePassword()||!form.checkValidity()){
            event.preventDefault();
            form.reportValidity();
        }
    });
});
