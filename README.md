# SimplyTime
A Garmin Connect IQ data field that displays the current time and optionally saves it to the FIT file when you end your activity.

The time displayed should be the same as shown on the watch face. By saving it in your activity FIT file you can visualise it in Garmin Connect and see not only where you were during the activity but also what time you were there.

You can disable saving the time from the app’s Garmin Connect Settings page. The default is on/save.

The Garmin Connect graphical display can only show decimal numbers. Time can’t be shown as hours:minutes so I show hours.minutes, e.g. 10:46 is shown as 10.46.

As a Garmin “Simple Data Field” the app has no control over the layout and font size it uses. With some layouts for some devices the Garmin firmware gets it wrong and makes the text too small.