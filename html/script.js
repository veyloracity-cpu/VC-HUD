// Erzwingt das Anzeigen der NUI, sobald die JS-Datei geladen wird
document.body.style.display = "block";

window.addEventListener('message', function(event) {
    let data = event.data;

    // Falls ein expliziter Show/Hide Event kommt
    if (data.action === "showHUD") {
        document.body.style.display = data.status ? "block" : "none";
    }

    if (data.action === "updateHUD") {
        document.body.style.display = "block"; // Stellt sicher, dass das HUD an ist
        
        document.getElementById("health-val").innerText = Math.round(data.health) + "%";
        document.getElementById("health-circle").setAttribute("stroke-dasharray", `${data.health}, 100`);

        document.getElementById("armor-val").innerText = Math.round(data.armor) + "%";
        document.getElementById("armor-circle").setAttribute("stroke-dasharray", `${data.armor}, 100`);

        document.getElementById("hunger-val").innerText = Math.round(data.hunger) + "%";
        document.getElementById("hunger-circle").setAttribute("stroke-dasharray", `${data.hunger}, 100`);

        document.getElementById("thirst-val").innerText = Math.round(data.thirst) + "%";
        document.getElementById("thirst-circle").setAttribute("stroke-dasharray", `${data.thirst}, 100`);

        document.getElementById("cash-amount").innerText = data.cash.toLocaleString();
        document.getElementById("bank-amount").innerText = data.bank.toLocaleString();
        document.getElementById("street-name").innerText = data.street;
    }

    if (data.action === "updateSpeed") {
        let speedEl = document.getElementById("speedometer");
        if (data.inVehicle) {
            speedEl.style.display = "block";
            let speed = Math.round(data.speed);
            document.getElementById("speed-val").innerText = speed.toString().padStart(3, '0');
            
            let maxSpeed = 240;
            let percentage = Math.min(speed / maxSpeed, 1);
            let dashoffset = 375 - (375 * 0.75 * percentage);
            document.getElementById("speed-gauge").style.strokeDashoffset = dashoffset;
            let angle = -120 + (percentage * 240);
            document.getElementById("needle").style.transform = `rotate(${angle}deg)`;
        } else {
            speedEl.style.display = "none";
        }
    }
});