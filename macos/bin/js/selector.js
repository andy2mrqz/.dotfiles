(function () {
  const getCssSelector = (el) => {
    if (el.id) return "#" + el.id;
    const p = el.parentElement ? getCssSelector(el.parentElement) + " > " : "",
      s = el.tagName.toLowerCase();
    return (
      p +
      s +
      (el.parentElement && el.parentElement.children.length > 1
        ? `:nth-child(${[...el.parentElement.children].indexOf(el) + 1})`
        : "")
    );
  };

  let last;
  const handleMouseOver = (e) => {
      last && (last.style.outline = "");
      e.stopPropagation();
      e.target.style.outline = "2px dashed red";
      last = e.target;
    },
    handleClick = (e) => {
      e.preventDefault();
      e.stopPropagation();
      last && (last.style.outline = "");
      document.removeEventListener("mouseover", handleMouseOver, true);
      document.removeEventListener("click", handleClick, true);
      const sel = getCssSelector(e.target);
      console.log("Copied selector:", sel);
      try {
        console.log(
          document.querySelector(sel) === e.target
            ? "✅ Selector uniquely identifies the element"
            : "⚠️ Selector doesn't uniquely identify the element"
        );
      } catch (err) {
        console.error("❌ Invalid selector:", err.message);
      }
      navigator.clipboard
        .writeText(sel)
        .then(() => console.log("Selector copied to clipboard!"))
        .catch((err) => console.error("Error copying text:", err));
    };
  document.addEventListener("mouseover", handleMouseOver, true);
  document.addEventListener("click", handleClick, true);
  console.log(
    "Selector picker active: hover and click an element to copy its CSS selector."
  );
})();
