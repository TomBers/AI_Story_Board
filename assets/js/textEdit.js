export default function setupQuill(ctx) {
  const element = ctx.el;
  const quill = new Quill(element, {
    theme: "snow",
    placeholder: "Compose an epic...",
  });

  content = JSON.parse(element.dataset.initialContent);

  if (content != null) {
    quill.setContents(content.ops);
  }

  callEvery20Seconds(ctx, quill);

  // quill.on("text-change", (delta, oldDelta, source) => {
  //   ctx.pushEvent("store-text", quill.getContents());
  // });

  quill.on("selection-change", (range, oldRange, source) => {
    if (range) {
      if (range.length == 0) {
        console.log("User cursor is on", range.index);
      } else {
        const text = quill.getText(range.index, range.length);
        console.log("User has highlighted", text);
      }
    } else {
      console.log("Cursor not in the editor");
    }
  });

  return quill;
}

function callEvery20Seconds(ctx, q) {
  ctx.pushEvent("store-text", q.getContents());
  // Call this function again after 20 seconds (20000), passing the same parameter
  setTimeout(() => callEvery20Seconds(ctx, q), 60000);
}

// Start the loop with a parameter
