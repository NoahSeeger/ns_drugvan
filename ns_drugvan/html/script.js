window.addEventListener("message", function (event) {
  if (event.data.action === "openMenu") {
    document.getElementById("cookingMenu").classList.remove("hidden");
  }
});

function startCooking(auto) {
  fetch(`https://${GetParentResourceName()}/startCooking`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({ auto: auto }),
  })
    .then((resp) => resp.json())
    .then((resp) => {
      console.log(resp);
    });
  closeMenu();
}

function closeMenu() {
  document.getElementById("cookingMenu").classList.add("hidden");
  fetch(`https://${GetParentResourceName()}/closeMenu`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify({}),
  });
}
