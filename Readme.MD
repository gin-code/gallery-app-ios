# Gallery App

Gallery App is an application that allows users to view and manage a collection of images. It provides features such as login functionality, multiple tab bars for different views, and a search bar for filtering images.

## Features

1. **Login Page:** The app includes a login page where users can enter their email address and password. During the first installation, any email address and password combination can be used, which will be saved in the keychain for future use. If the credentials are forgotten, a "Reset Keychain" button is provided to reset everything and enter new credentials.

2. **Main Application Tab Bars:** The main application consists of three tab bars: List View, Grid View, and Settings.

3. **List View:** This tab displays a table view implementation of the pictures fetched from the Pexels API. Each cell in the table represents an image with its associated photographer name and description. Single-clicking on a cell opens the image in a new screen that supports left and right swipe gestures for navigation.

4. **Multiple Cell Selection:** Long-pressing on a cell in List View or Grid View highlights the cell and enables multiple cell selection. Users can select multiple cells by long-pressing on each desired cell.

5. **Cell Actions:** Once a cell is highlighted, a top bar becomes visible, providing options to delete the selected cell(s). It's important to note that when a cell is highlighted, the user cannot open a new window to view images unless the selection is deselected with a simple tap.

6. **Grid View:** This tab displays a collection view implementation of the images obtained from the Pexels API. The same multiple cell selection and actions as mentioned in List View are applicable here as well.

7. **Settings Page:** The Settings tab hosts a logout button for users to sign out from their account. Additionally, it includes a search bar for filtering images based on simple queries, such as car, table, office, human, nature, trees, etc.

8. **Search Functionality:** To utilize the search functionality, users need to open the respective tab (List View or Grid View) before entering a search query in the search bar. This updates the search results accordingly.

9. **Image Details:** As the Pexels API does not provide image names and dates, the app displays the "Photographer Name" and "Description" associated with each image.

## Author

Gallery App is developed by Sparsh Singh.

## License

This project is licensed under the [MIT License](LICENSE).

