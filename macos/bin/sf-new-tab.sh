#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title sf-new-tab
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ❄️

# Documentation:
# @raycast.author Andrew Marquez

osascript <<EOF
tell application "Arc"
    activate
    tell the active tab of its first window
        execute javascript "
(() => {
  const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

  const findElement = (selector, errorMessage) => {
    const element = document.querySelector(selector);
    if (!element) {
      console.warn(errorMessage);
      throw new Error(errorMessage);
    }
    return element;
  };

  const findElementByText = (elements, text, errorMessage) => {
    const element = elements.find((el) => el.innerHTML.trim() === text);
    if (!element) {
      console.warn(errorMessage);
      throw new Error(errorMessage);
    }
    return element;
  };

  const findAndClickInSessionContext = (text) => {
    const sessionContextDiv = findElement(
      'div[name=\"SESSION_CONTEXT\"]',
      \"Session context not found\"
    );
    const allDivsInContext = Array.from(
      sessionContextDiv.querySelectorAll(\"div\")
    );
    const divToFind = findElementByText(
      allDivsInContext,
      text,
      \`\${text} not found\`
    );
    divToFind.click();
  }

  const main = async () => {
    try {
      const newSheetButton = findElement(
        'svg[aria-label=\"Create SQL worksheet\"]',
        \"New sheet button not found\"
      ).parentElement;
      newSheetButton.click();

      await wait(1000);

      const roleAndWarehouseSelector = findElement(
        '[data-testid=\"roleAndWarehouseSelector\"]',
        \"Role and Warehouse selector not found\"
      );
      roleAndWarehouseSelector.click();
      await wait(1000);

      // choose which role and warehouse to use
      findAndClickInSessionContext(\"DATA_SCIENCE_ROLE\");
      await wait(1500);
      findAndClickInSessionContext(\"ADHOC_WH\");

      // close the role and warehouse menu
      roleAndWarehouseSelector.click();
    } catch (error) {
      console.error(\"An error occurred:\", error);
    }
  };

  main();
})();
        "
    end tell
end tell
return
EOF
