
document.addEventListener("DOMContentLoaded", function () { document.querySelectorAll(".logo img").forEach(function (img) { img.addEventListener("error", function () { img.alt = "QueueLess logo image could not be loaded" }) }) })

const loginChoiceBtn = document.getElementById("loginChoiceBtn");
const loginModal = document.getElementById("loginModal");
const closeLoginModal = document.getElementById("closeLoginModal");
const loginBackdrop = document.getElementById("loginBackdrop");
function openLoginModal() { loginModal.classList.add("open"); loginModal.setAttribute("aria-hidden", "false"); document.body.classList.add("login-modal-open"); closeLoginModal.focus() }
function hideLoginModal() { loginModal.classList.remove("open"); loginModal.setAttribute("aria-hidden", "true"); document.body.classList.remove("login-modal-open"); loginChoiceBtn.focus() }
loginChoiceBtn.addEventListener("click", openLoginModal);
closeLoginModal.addEventListener("click", hideLoginModal);
loginBackdrop.addEventListener("click", hideLoginModal);
document.addEventListener("keydown", event => { if (event.key === "Escape" && loginModal.classList.contains("open")) hideLoginModal() });
