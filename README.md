# Ten-Grand #
An iOS app that allows you to keep track of time spent on activities.

##### BASED ON THE CONCEPT OF 10,000 HOURS, KEEP TRACK OF TIME SPENT ON ALL OF YOUR ACTIVITIES! #####

This is a Core Data app that allows you to create accounts and track time in the form of money. A user can see their total net worth when they first open the app that consists of the total amount of time the user has ever added to current and past accounts.

If the user has never opened the app before, they will be prompted with a pop up that explains the app. All they have to do is tap anywhere on the screen to dismiss the pop up. If the user has visited the app before the user will be prompted with the same pop up, but instead it will display an inspirational quote of the day downloaded from the web. The pop up keeps track of whether the user has seen the pop up for that day and will not show it again even if the user terminates the app.

In the top right of the home screen, there is a present button. This pushes on a page that shows a collection view of all the items in the store(10 in total). In the top right of the new page is an info button. Clicking on it tells the user how the store works. The user will see a display on the new page that shows their current cash. They can use this cash to buy things in the store. While the cash goes up when the users net worth increases, when it goes down the net worth does not. They can click on any of the items in the store and it will display a pop up of the description of the item and a buy button with the price followed by a dismiss button. They can hit the buy button, if they have enough for the purchase the buy button will disappear forever and the item in the collection view will turn gold. If the user doesn't have enough money the button will turn red then back to the orginal color showing the purchase failed.

On the bottom of the screen is another tab button. This will take you to the accounts page. When you add new accounts it will display them in a table view. The table view will show the name of the account, the amount in the account and a progress bar that shows a gold bar inside a grey bar that's based on the amount in the account versus the goal of $10,000.00.

In the top right of the accounts screen, there is an add account button. This presents a screen to add a new account. You can enter the account name in the text field. You can either hit the create button or cancel button.

If you click on one of your accounts, it will push on the details and timer for that account. On the account detail page you will see the same thing as the table view at the top and a new label to show your time in hours, minutes and seconds below it. In the middle of the screen will be the timer that you can tap to start and tap again to stop as it tracks the time. At the bottom is three buttons. The check mark button will save the time if the timer is stopped, The x mark button will clear the timer when the timer is stopped, and the log button will open a pop up with all the times you have saved to the account. In the top right of the screen is a delete account button. Clicking on it will change the screen content to include a label that asks if you want to delete the account, and two buttons. The delete button will delete the account and pop you back to the accounts page. The cancel button will put the timer back on the screen and not delete the account.

The timer will continue running even if the user terminates the app. When they go back to the account the timer will show the amount of time since they started the timer. The user can also pause the timer and terminate the app, when they go back to the screen the time they paused at is in the timer. The table view of all of the accounts will turn green for the accounts that have an active running timer.

# Running The Project #
You can download the project and run the Ten Grand.xcworkspace file in the iOS simulator.
