using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Application.Properties as Props;
using Toybox.Activity;
using Toybox.Time;
using Toybox.FitContributor;
using Toybox.System as Sys;

const cRecordTime = true;
const TIME0_FIELD_ID = 0;

enum {
	TIMER_STATE_OFF = 0,
	TIMER_STATE_STOPPED = 1,
	TIMER_STATE_PAUSED = 2,
	TIMER_STATE_ON = 3
}

class SimplyTimeSDFView extends WatchUi.SimpleDataField {
    hidden var mTimerState = TIMER_STATE_OFF;

    hidden var FitTimeField = null;
    hidden var mRecordTime = true;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Clock Time";
		var tRecordTime = null;

		if ( App has :Properties ) {
	        tRecordTime = Props.getValue("recordData");
	    } else {
			var thisApp = App.getApp();
	        tRecordTime = thisApp.getProperty("recordData");
	    }
// maybe set up the FITContributor
       	mRecordTime = (tRecordTime == null) ? cRecordTime : (tRecordTime != 0);
        if (mRecordTime) {
        	var units = "Hr.Min";
			FitTimeField = DataField.createField(
				"Clock Time",
				TIME0_FIELD_ID,
				FitContributor.DATA_TYPE_FLOAT,
				{:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>units}
        	);
		}
    }

    function onTimerStart()
    {
        mTimerState = TIMER_STATE_ON;
    }

    //! The timer was stopped, so set the state to stopped.
    //! and zero counters so we can restart from the beginning
    function onTimerStop()
    {
        mTimerState = TIMER_STATE_STOPPED;
    }

    //! The timer was paused, so set the state to paused.
    function onTimerPause()
    {
        mTimerState = TIMER_STATE_PAUSED;
    }

    //! The timer was restarted, so set the state to running again.
    function onTimerResume()
    {
        mTimerState = TIMER_STATE_ON;
    }

    //! The timer was reset, so reset all our tracking variables
    function onTimerReset()
    {
        mTimerState = TIMER_STATE_OFF;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
		var moment = Time.now();
		var now = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
	    var hour;
	    
		if (Sys.getDeviceSettings().is24Hour) {
			hour = now.hour;
		} else {
			hour = now.hour % 12;
			if (hour == 0) {
				hour = 12;
			}
		}

        if (mTimerState == TIMER_STATE_ON && mRecordTime) {
// for recording eg 3:24 will be displayed by Connect as 3.24
			var rTime = hour + (now.min.toDouble() / 100);
   			FitTimeField.setData(rTime);
		}

		var dTime = hour.format("%02d") + ":" + now.min.format("%02d");
		return dTime;
    }
    
}