import { LiveSocket } from "phoenix_live_view";

export default function setupQuill(ctx) {
  let popUp;
  const element = ctx.el;
  const quill = new Quill(element, {
    theme: "snow",
    placeholder: "Compose an epic...",
  });

  content = JSON.parse(element.dataset.initialContent);

  if (content != null) {
    quill.setContents(content.ops);
  }

  // callEvery20Seconds(ctx, quill);

  // quill.on("text-change", (delta, oldDelta, source) => {
  //   ctx.pushEvent("store-text", quill.getContents());
  // });

  quill.on("selection-change", (range, oldRange, source) => {
    if (range) {
      if (range.length == 0) {
        removePopup(popUp);
        console.log("User cursor is on", range.index);
      } else {
        removePopup(popUp);
        const text = quill.getText(range.index, range.length);
        popUp = drawPopUp(ctx, window.mouseX, window.mouseY, text);
      }
    } else {
      // removePopup(popUp);
      console.log("Cursor not in the editor");
    }
  });

  return quill;
}

function removePopup(popup) {
  try {
    document.body.removeChild(popup);
  } catch (e) {
    console.log("No popup");
  }
}

function drawPopUp(ctx, x, y, text) {
  // Create a new div element
  const popUp = document.createElement("div");

  // Set the text content of the div
  popUp.innerHTML = `Create panel`;

  // Apply some basic styles to the div
  popUp.style.position = "absolute"; // Position the div relative to the page
  popUp.style.left = x + "px"; // Set the left position
  popUp.style.top = y + "px"; // Set the top position
  popUp.style.padding = "10px"; // Add some padding
  popUp.style.backgroundColor = "#f9f9f9"; // Set a background color
  popUp.style.border = "1px solid #ccc"; // Add a border
  popUp.style.cursor = "pointer"; // Make it look clickable
  popUp.style.zIndex = "1000"; // Ensure it appears above other elements

  // Make the div clickable
  popUp.addEventListener("click", function () {
    ctx.pushEvent("create-panel", { selection: text });
    openDrawer();
    removePopup(popUp);
  });

  // Add the div to the body
  document.body.appendChild(popUp);
  return popUp;
}

function callEvery20Seconds(ctx, q) {
  ctx.pushEvent("store-text", q.getContents());
  // Call this function again after 20 seconds (20000), passing the same parameter
  setTimeout(() => callEvery20Seconds(ctx, q), 60000);
}

function openDrawer() {
  const drawer = document.getElementById("drawerForm");

  // Ensure the initial state is applied
  drawer.classList.remove("translate-x-0");
  drawer.classList.add("translate-x-full");

  // Use a slight delay to trigger the transition
  setTimeout(() => {
    drawer.classList.remove("translate-x-full");
    drawer.classList.add("translate-x-0");
  }, 100); // 10ms delay to ensure state is applied before transition
}

// Start the loop with a parameter
