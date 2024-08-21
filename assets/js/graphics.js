// Potential params
// Font
// Font size
// Text Color
// Rect Color
// Text Position 9 pos, left, center, right * top, middle, bottom

export default function drawPanel({ text, canvasId, imgUrl }) {
  const canvas = document.getElementById(canvasId);
  const ctx = canvas.getContext("2d");

  const img = new Image();
  img.src = imgUrl;

  // Draw the image and text on the canvas once the image has loaded
  img.onload = function () {
    // Draw the image on the canvas
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.font = "40px Arial";

    measure = ctx.measureText(text);

    const padding = 15;
    const width = measure.width + padding;
    const height =
      measure.actualBoundingBoxAscent +
      measure.actualBoundingBoxDescent +
      padding;

    const x = canvas.width / 2; // Center horizontally
    // const y = canvas.height / 2; // Center vertically
    const y = canvas.height - height / 2;

    ctx.rect(x - width / 2, y - height / 2, width, height);
    ctx.fillStyle = "black";
    ctx.fill();

    // Set text properties
    ctx.fillStyle = "white";

    // Position and draw the text over the image
    ctx.fillText(text, x, y);
  };
}
