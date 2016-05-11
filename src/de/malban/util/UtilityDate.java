package de.malban.util;


import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 */
public class UtilityDate
{
    /** Definition when a WorkHour starts. */
    public static final int WORK_START_HOUR = 9;

    /** Definition when a WorkHour ends. */
    public static final int WORK_END_HOUR = 17;

    /**  */
    public static final int YEAR_MAX = 20;

    private static GregorianCalendar mCalendar;
    // calendar is not changed by "small" methods (?)
    private static GregorianCalendar mCalendar_t; // localy changeable calendar

    // year, month, day (all 0 based! -> [0][0][0] ist the first of January 2000!)
    private static boolean[][][] mHolydays = new boolean[YEAR_MAX][12][31];

    static {
            mCalendar = new GregorianCalendar();
            mCalendar_t = new GregorianCalendar();

            // initialize all (known) holydays
            for (int y = 0; y < YEAR_MAX; y++) {
                    for (int m = 0; m < 12; m++) {
                            for (int d = 0; d < 31; d++) {
                                    mHolydays[y][m][d] = false;
                            }
                    }
                    // each year the follwing days are holydays!

                    mHolydays[y][0][0] = true; // new years day
                    mHolydays[y][4][0] = true; // first of May
                    mHolydays[y][9][2] = true; // third of october
                    mHolydays[y][11][23] = true; // chri stmas eve
                    mHolydays[y][11][24] = true; // ...
                    mHolydays[y][11][25] = true; //
                    mHolydays[y][11][26] = true; //
                    mHolydays[y][11][27] = true; //
                    mHolydays[y][11][28] = true; //
                    mHolydays[y][11][29] = true; //
                    mHolydays[y][11][30] = true; //
            }

            // example
            // additional holydays 2003
            mHolydays[3][0][5] = true;
            mHolydays[3][2][2] = true;
            mHolydays[3][3][17] = true;
            mHolydays[3][4][1] = true;
            mHolydays[3][4][28] = true;
            mHolydays[3][5][8] = true;
            mHolydays[3][5][18] = true;

            // additional holydays 2004
            // only Chri stmas
    }

    /** Format a Date, that the hour, minute and second are reset to 0.
     *  Millis (getTime(), can still be different!
     */
    static public Date earlyDay(Date d) {
            mCalendar_t.setTime(d);
            mCalendar_t.set(Calendar.HOUR_OF_DAY, 0);
            mCalendar_t.set(Calendar.MINUTE, 0);
            mCalendar_t.set(Calendar.SECOND, 0);
            return mCalendar_t.getTime();
    }

	/** Format a Date, that the hour is set to 23, minute and second are set to 59.
	*/
	static public Date lateDay(Date d) {
		mCalendar_t.setTime(d);
		mCalendar_t.set(Calendar.HOUR_OF_DAY, 23);
		mCalendar_t.set(Calendar.MINUTE, 59);
		mCalendar_t.set(Calendar.SECOND, 59);
		return mCalendar_t.getTime();
	}
	/** Gets an integer value for a date.
	     * The integer value is equal when the date (not considering the time) is equal.
	 * A dayValue is smaller than another if the date is earlier.
	 */
	static public int getDayValue(Date d) {
		mCalendar_t.setTime(d);
		int year = mCalendar_t.get(Calendar.YEAR);
		int day = mCalendar_t.get(Calendar.DAY_OF_YEAR);
		int value = year * 1000 + day;
		return value;
	}
        static public boolean isSameDay(Date d1, Date d2)
        {
            return getDayValue(d1) == getDayValue(d2);
        }
        
       /** Get a boolean value whether a date is a holyday.
	 * Fixed holydays are (rmany):<BR>
	 *
	 *	new years day <BR>
	 * first May<BR>
	 * third october<BR>
	 * Days between 23.12 and 01.01.(next year)<BR>
	 * Sundays, Saturdays <BR>
	 * Additionally for year 2002 and 2003 the usual holydays are used (including "Gleittage")
	 */
	public static boolean isWorkday(GregorianCalendar calendar) {
		int type = calendar.get(Calendar.DAY_OF_WEEK);
		if ((type == Calendar.SUNDAY) || (type == Calendar.SATURDAY)) {
			return false;
		}
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		int month = calendar.get(Calendar.MONTH);
		int year = calendar.get(Calendar.YEAR);
		if ((year < 2000) || (year > 2000+YEAR_MAX)) {
			return true;
		}

		// workday is NOT holyday!
		return !mHolydays[year - 2000][month][day - 1];
	}
        static Date fixWorkHours(Date date)
	{
		if (date == null)
		{
			return null;
		}
		mCalendar_t.setTime(date);
		if (mCalendar_t.get(Calendar.HOUR_OF_DAY) > WORK_END_HOUR)
		{
			mCalendar_t.set(Calendar.HOUR_OF_DAY, WORK_END_HOUR);
			mCalendar_t.set(Calendar.MINUTE, 0);
			mCalendar_t.set(Calendar.SECOND, 0);
		}
		if (mCalendar_t.get(Calendar.HOUR_OF_DAY) < WORK_START_HOUR)
		{
			mCalendar_t.set(Calendar.HOUR_OF_DAY, WORK_START_HOUR);
			mCalendar_t.set(Calendar.MINUTE, 0);
			mCalendar_t.set(Calendar.SECOND, 0);
		}
		return mCalendar_t.getTime();
	}

        /** Return how many workhours are between two dates.
	 * Workhours between WORK_START_HOUR (9:00) and WORK_END_HOUR (17:00),
	 * sundays and saturdays are discarded.
	 * Holydays are got by testing the date via isWorkday().<BR>
	 * Returns -1 on error. (e.g. date2 or date1 = null).<BR>
	 * Negative values are returned if date2 < date1.<BR>
	 */
	public static int getWorkHours(Date date1, Date date2) 
	{
		int workDays = -1; // the 1 and last Day are handled by single hours!
		int hours = 0;
		int minus = 1;

		date1 = fixWorkHours(date1);
		date2 = fixWorkHours(date2);

		if (date2 == null) 
		{
			return -1;
		}
		if (date2 == null) 
		{
			return -1;
		}

		if (date2.before(date1)) 
		{
			minus = -1;
			Date t = date2;
			date2 = date1;
			date1 = t;
		}

		mCalendar.setTime(date1);
		
		hours = WORK_END_HOUR - mCalendar.get(Calendar.HOUR_OF_DAY);
		if (hours < 0) 
		{
			hours = 0;
		}

		while (getDayValue(mCalendar.getTime()) != getDayValue(date2)) 
		{
			if (isWorkday(mCalendar)) 
			{
				workDays++;
			}

			increaseDay(mCalendar);

		}

		mCalendar.setTime(date2);
		
		// gefixed am gleichen Tag
		if (getDayValue(date1) == getDayValue(date2)) 
		{
			hours -= (WORK_END_HOUR - mCalendar.get(Calendar.HOUR_OF_DAY));
		} 
		else 
		{
			if (mCalendar.get(Calendar.HOUR_OF_DAY) > WORK_START_HOUR) 
			{
				hours += mCalendar.get(Calendar.HOUR_OF_DAY) - WORK_START_HOUR;
			}
			
			if (workDays > 0) 
			{
				hours += (workDays) * 8;
			}
		}
		return hours * minus;
	}
	
        public static int getAbsolutHours(Date date1, Date date2) 
        {
		int workDays = -1; // the 1 and last Day are handled by single hours!
		int hours = 0;
		int minus = 1;

		if (date2 == null) 
		{
			return -1;
		}
		if (date2 == null) 
		{
			return -1;
		}

		if (date2.before(date1)) 
		{
			minus = -1;
			Date t = date2;
			date2 = date1;
			date1 = t;
		}

		mCalendar.setTime(date1);
		
		hours = mCalendar.get(Calendar.HOUR_OF_DAY);

		while (getDayValue(mCalendar.getTime()) != getDayValue(date2)) 
		{
                    workDays++;
                    increaseDay(mCalendar);
		}

		mCalendar.setTime(date2);
		
		// gefixed am gleichen Tag
		if (getDayValue(date1) == getDayValue(date2)) 
		{
                    hours -= (mCalendar.get(Calendar.HOUR_OF_DAY));
                    hours *=-1;
		} 
		else 
		{
                    hours += mCalendar.get(Calendar.HOUR_OF_DAY);
                    if (workDays > 0) 
                    {
                        hours += (workDays) * 24;
                    }
		}
		return hours * minus;
        }
        
        public static Date incDay(Date d)
        {
            mCalendar_t.setTime(d);
            increaseDay(mCalendar_t);
            return mCalendar_t.getTime();
        }
        
        /** Increase the given Calendar by one day.
	 * Day, month overflows are handled correctly.
	 */
	public static void increaseDay(Calendar c) {
		/* increase Calendar 1 day */
		int t = c.get(Calendar.DAY_OF_MONTH);
		c.roll(Calendar.DAY_OF_MONTH, true);
		if (c.get(Calendar.DAY_OF_MONTH) < t) {
			t = c.get(Calendar.MONTH);
			c.roll(Calendar.MONTH, true);
			if (c.get(Calendar.MONTH) < t) {
				c.roll(Calendar.YEAR, true);
			}
		}
	}

	/** Get the given months (0 based) as an english name.
	 * (Should be localized!)
	 */
	public static String getMonthName(int month) {
		switch (month) {
			case 0 :
				return "January";
			case 1 :
				return "February";
			case 2 :
				return "March";
			case 3 :
				return "April";
			case 4 :
				return "May";
			case 5 :
				return "June";
			case 6 :
				return "July";
			case 7 :
				return "August";
			case 8 :
				return "September";
			case 9 :
				return "October";
			case 10 :
				return "November";
			case 11 :
				return "December";
		}
		return "unkown Month";
	}

	/** Get the year of a given date.
	 */
	public static int getYear(Date date) {
		mCalendar_t.setTime(date);
		return mCalendar_t.get(Calendar.YEAR);
	}

	/** Get the month (0 based) of a given date.
	 */
	public static int getMonth(Date date) {
		mCalendar_t.setTime(date);
		return mCalendar_t.get(Calendar.MONTH);
	}

	/** Get the day of the week of a given date.
	 * (result as defined in java.util.Calendar)
	 */
	public static int getDayOfWeek(Date date) {
		mCalendar_t.setTime(date);
		return mCalendar_t.get(Calendar.DAY_OF_WEEK);
	}
       
        public static Date earlyMonth(Date date)
        {
            mCalendar_t.setTime(date);
            mCalendar_t.set(Calendar.DAY_OF_MONTH, 1);
            mCalendar_t.set(Calendar.HOUR_OF_DAY, 0);
            mCalendar_t.set(Calendar.MINUTE, 0);
            mCalendar_t.set(Calendar.SECOND, 0);
            return mCalendar_t.getTime();
        }
        
        public static Date incMonth(Date date)
        {
            mCalendar_t.setTime(date);
            
            int m = mCalendar_t.get(Calendar.MONTH);
            m++;
            if (m>=12) 
            {
                m=0;
                int y = mCalendar_t.get(Calendar.YEAR);
                mCalendar_t.set(Calendar.YEAR, y+1);
            }
            mCalendar_t.set(Calendar.MONTH, m);
            return mCalendar_t.getTime();
        }

        public static Date decMonth(Date date)
        {
            mCalendar_t.setTime(date);
            
            int m = mCalendar_t.get(Calendar.MONTH);
            m--;
            if (m<0) 
            {
                m=11;
                int y = mCalendar_t.get(Calendar.YEAR);
                mCalendar_t.set(Calendar.YEAR, y-1);
            }
            mCalendar_t.set(Calendar.MONTH, m);
            return mCalendar_t.getTime();
        }

        /**Get a Date of a string that is like : YYYY-MM-DD (Late Day)
         * 
         * @param date
         * @return Date as from String, returned as lateDay(d)
         * @see #lateDay(Date d)
        */
        public static Date getDateFromString(String date)
        {
            Date d = new Date();
            if (date == null) return lateDay( d);
            if (date.length()==0) return lateDay( d);
            try
            {
                mCalendar_t.set(
                        Integer.parseInt(date.substring(0, 0+4)), // year
                        Integer.parseInt(date.substring(5, 5+2))-1, // month
                        Integer.parseInt(date.substring(8, 8+2)) // day
                        );
            
               d = mCalendar_t.getTime();
            }
            catch (Throwable t)
            {
                
            }
            return lateDay(d);
        }
        public static Date getDateFromStringEarly(String date)
        {
            Date d = new Date();
            if (date == null) return earlyDay( d);
            if (date.length()==0) return earlyDay( d);
            try
            {
                mCalendar_t.set(
                        Integer.parseInt(date.substring(0, 0+4)), // year
                        Integer.parseInt(date.substring(5, 5+2))-1, // month
                        Integer.parseInt(date.substring(8, 8+2)) // day
                        );
            
               d = mCalendar_t.getTime();
            }
            catch (Throwable t)
            {
                
            }
            return earlyDay(d);
        }

        // from a string like 1.2.2009 oder 10.12.2009
        public static Date getDateFromStringGerman(String date)
        {
            Date d = new Date();
            if (date == null) return earlyDay( d);
            if (date.length()==0) return earlyDay( d);
            
            String t = UtilityString.replace(date, " ","");
            String[] teile=t.split("\\.");
            if (teile.length<=1) 
                teile=t.split("-");
            if (teile.length<=1) 
                teile=t.split(",");
            if (teile.length<=1) 
                teile=t.split(" ");
            try
            {
                mCalendar_t.set(
                        Integer.parseInt(teile[2]), // year
                        Integer.parseInt(teile[1])-1, // month
                        Integer.parseInt(teile[0]) // day
                        );
            
               d = mCalendar_t.getTime();
            }
            catch (Throwable tt)
            {
                
            }
            return earlyDay(d);
        }
        
        
        /**Get a Date of a string that is like : YYYY-MM-DD HH:MM:SS
         * 
         * @param oracleDate
         * @return Data, if not hour, minute, second ist supplied, earlyDay(d) will be returned
         */
	public static Date getDate(String oracleDate) 
        {
            if (oracleDate == null) return null;
            try
            {
                  
                if (oracleDate.length() > 12)
                {
                    mCalendar_t.set(
                        Integer.parseInt(oracleDate.substring(0, 0+4)), // year
                        Integer.parseInt(oracleDate.substring(5, 5+2))-1, // month
                        Integer.parseInt(oracleDate.substring(8, 8+2)), // day


                        Integer.parseInt(oracleDate.substring(11, 11+2)), // hour
                        Integer.parseInt(oracleDate.substring(14, 14+2)), // min
                        Integer.parseInt(oracleDate.substring(17, 17+2)) // sec

                        );        
                    return mCalendar_t.getTime();
                }
                else
                {
                    mCalendar_t.set(
                        Integer.parseInt(oracleDate.substring(0, 0+4)), // year
                        Integer.parseInt(oracleDate.substring(5, 5+2))-1, // month
                        Integer.parseInt(oracleDate.substring(8, 8+2)) // day
                        );        
                    return earlyDay(mCalendar_t.getTime());
                }

            }
            catch (Throwable e){}
            return null;
        }

        // yyyy?mm?dd
	public static Date getDateOnly(String oracleDate) 
        {
            if (oracleDate == null) return null;
            try
            {
                mCalendar_t.set(
                    Integer.parseInt(oracleDate.substring(0, 0+4)), // year
                    Integer.parseInt(oracleDate.substring(5, 5+2))-1, // month
                    Integer.parseInt(oracleDate.substring(8, 8+2)) // day
                    );        

                return earlyDay(mCalendar_t.getTime());
            }
            catch (Throwable e){}
            return null;
        }

        // YYYY-MM-DD
    public static String dateToString(Date date)
    {
        if (date==null) return "";
        
        Calendar ca = Calendar.getInstance();
        ca.setTime(earlyDay(date));

        String dates = ""+ca.get(Calendar.YEAR)+"-";
        if ((ca.get(Calendar.MONTH)+1)<10) 
            dates +="0"+(ca.get(Calendar.MONTH)+1)+"-";
        else
            dates +=""+(ca.get(Calendar.MONTH)+1)+"-";
        if (ca.get(Calendar.DAY_OF_MONTH)<10) 
            dates +="0"+(ca.get(Calendar.DAY_OF_MONTH))+"";
        else
            dates +=""+(ca.get(Calendar.DAY_OF_MONTH))+"";
        return dates;
    }

    // dd.mm.yyyy
    public static String dateToStringGerman(Date date)
    {
        if (date==null) return "";
        Calendar ca = Calendar.getInstance();
        ca.setTime(date);
        String dates="";
        if (ca.get(Calendar.DAY_OF_MONTH)<10) 
            dates +="0"+(ca.get(Calendar.DAY_OF_MONTH))+".";
        else
            dates +=""+(ca.get(Calendar.DAY_OF_MONTH))+".";

        if ((ca.get(Calendar.MONTH)+1)<10) 
            dates +="0"+(ca.get(Calendar.MONTH)+1)+".";
        else
            dates +=""+(ca.get(Calendar.MONTH)+1)+".";
        dates += ""+ca.get(Calendar.YEAR)+"";
        return dates;
    }
        
    // dd.mm.yyyy 01:11:12
    public static String dateToStringGermanClock(Date date)
    {
        if (date==null) return "";
        Calendar ca = Calendar.getInstance();
        ca.setTime(date);
        String dates="";
        if (ca.get(Calendar.DAY_OF_MONTH)<10)
            dates +="0"+(ca.get(Calendar.DAY_OF_MONTH))+".";
        else
            dates +=""+(ca.get(Calendar.DAY_OF_MONTH))+".";

        if ((ca.get(Calendar.MONTH)+1)<10)
            dates +="0"+(ca.get(Calendar.MONTH)+1)+".";
        else
            dates +=""+(ca.get(Calendar.MONTH)+1)+".";
        dates += ""+ca.get(Calendar.YEAR)+"";

        dates +=" ";
        int h = ca.get(Calendar.HOUR_OF_DAY);
        if (h<10)
            dates +="0"+ h;
        else
            dates +=h;
        dates +=":";

        int m = ca.get(Calendar.MINUTE);
        if (m<10)
            dates +="0"+ m;
        else
            dates +=m;
        dates +=":";

        int s = ca.get(Calendar.SECOND);
        if (s<10)
            dates +="0"+ s;
        else
            dates +=s;



        return dates;
    }
    public static int getKW(Date date)
    {
        int kw=-1;
        Calendar ca = Calendar.getInstance();
        ca.setTime(date);
        ca.setFirstDayOfWeek(Calendar.MONDAY);
        kw = ca.get(Calendar.WEEK_OF_YEAR);
        return kw;
    }

}
