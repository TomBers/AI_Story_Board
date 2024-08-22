export default function drawPanel({ text, canvasId, imgUrl, textConfig }) {
  const tc = JSON.parse(textConfig);

  console.log(tc);

  const canvas = document.getElementById(canvasId);
  const ctx = canvas.getContext("2d");

  const img = new Image();
  img.src = imgUrl;

  // Draw the image and text on the canvas once the image has loaded
  img.onload = function () {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    // Draw the image on the canvas
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

    ctx.textAlign = "center";
    ctx.textBaseline = "middle";

    const font = `${tc["font_size"]}px ${tc["font"]}`;
    console.log(font);
    ctx.font = font;

    measure = ctx.measureText(text);

    const padding = 15;
    const width = measure.width + padding;
    const height =
      measure.actualBoundingBoxAscent +
      measure.actualBoundingBoxDescent +
      padding;

    const x = tc["x"];
    // const y = canvas.height / 2; // Center vertically
    const y = tc["y"];

    ctx.beginPath();
    ctx.rect(x - width / 2, y - height / 2, width, height);
    ctx.closePath();
    ctx.fillStyle = tc["background_col"];
    ctx.fill();

    // Set text properties
    ctx.fillStyle = tc["text_col"];

    // Position and draw the text over the image
    ctx.fillText(text, x, y);
  };
}
