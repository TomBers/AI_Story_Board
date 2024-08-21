export default function drawPanel({ text, canvasId, imgUrl }) {
  const canvas = document.getElementById(canvasId);
  const ctx = canvas.getContext("2d");

  const img = new Image();
  img.src = imgUrl;

  // Draw the image and text on the canvas once the image has loaded
  img.onload = function () {
    // Draw the image on the canvas
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

    // Set text properties
    ctx.font = "40px Arial";
    ctx.fillStyle = "white";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";

    // Position and draw the text over the image
    const x = canvas.width / 2; // Center horizontally
    const y = canvas.height / 2; // Center vertically
    ctx.fillText(text, x, y);
  };
}
