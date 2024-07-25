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

  const main = async () => {
    try {
      const newSheetButton = findElement(
        'svg[aria-label=\"Open new worksheet tab\"]',
        \"New sheet button not found\"
      ).parentElement;
      newSheetButton.click();

      const allDivs = Array.from(document.querySelectorAll(\"div\"));
      const newSqlWorksheetButton = findElementByText(
        allDivs,
        \"SQL Worksheet\",
        \"New SQL worksheet button not found\"
      );
      newSqlWorksheetButton.click();
      await wait(1000);

      const roleAndWarehouseSelector = findElement(
        '[data-testid=\"roleAndWarehouseSelector\"]',
        \"Role and Warehouse selector not found\"
      );
      roleAndWarehouseSelector.click();
      await wait(250);

      const sessionContextDiv = findElement(
        'div[name=\"SESSION_CONTEXT\"]',
        \"Session context not found\"
      );
      const allDivsInContext = Array.from(
        sessionContextDiv.querySelectorAll(\"div\")
      );
      const dataScienceRoleDiv = findElementByText(
        allDivsInContext,
        \"DATA_SCIENCE_ROLE\",
        \"DATA_SCIENCE_ROLE not found\"
      );
      dataScienceRoleDiv.click();
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
