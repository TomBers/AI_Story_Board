const { drawText, getTextHeight } = window.canvasTxt;

export default function drawPanel({ text, canvasId, imgUrl, textConfig }) {
  const tc = JSON.parse(textConfig);

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
    ctx.font = font;

    // measure = ctx.measureText(text);

    const width = tc["text_width"];
    const height = getTextHeight({ ctx, text, font });

    const x = tc["x"];
    const y = tc["y"];

    // Set text properties

    res = drawText(ctx, text, {
      x: x,
      y: y,
      width: width,
      height: height,
      font: tc["font"],
      fontSize: tc["font_size"],
    });

    drawBackground(
      ctx,
      x,
      y,
      width,
      res.height,
      tc["background_col"],
      Math.max(5, height),
    );

    ctx.font = font;
    ctx.fillStyle = tc["text_col"];
    drawText(ctx, text, {
      x: x,
      y: y,
      width: width,
      height: height,
      font: tc["font"],
      fontSize: tc["font_size"],
    });
  };
}

function drawBackground(ctx, x, y, width, height, col, padding) {
  ctx.beginPath();
  ctx.rect(x, y - height / 2, width, height + padding);
  ctx.closePath();
  ctx.fillStyle = col;
  ctx.fill();
}
