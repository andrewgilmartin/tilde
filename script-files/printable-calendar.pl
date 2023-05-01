#!/usr/bin/perl -w

# Script to create an HTML encoded calendar of several contiguous weeks 
# starting from the current week.
#
# usage: printable-calendar > calendar.html

use strict;
use DateTime;

my $tz = DateTime::TimeZone->new( name => 'local' );

#my $date = DateTime->new( year => 2014, month => 6, day => 22, time_zone => $tz );

my $date = DateTime->now( time_zone => $tz )->set( hour => 0, minute => 0, second => 0 );

# set date to previous Sunday if today is not Sunday
$date->add( days => - $date->day_of_week  ) if $date->day_of_week != 7;

my $weeks = 53 - $date->week_number();
#my $weeks = 16;

my $page = qq~
<html>
    <head>
            <style>
                    html {
                        color: gray;
                    }

                    table, th, td {
                        border: 1px solid black;
                    }

                    table {
                        border-collapse: collapse;
                        width: 7in;
                    }

                    tr {
                    	/* does not work as of 2014-06 but perhaps it will soon */
                        page-break-inside:avoid;
                        page-break-after:auto
                    }

                    td {
                        padding: 1ex;
                        height: 1in;
                        width: 1in;
                        text-align: left;
                        vertical-align: bottom;
                    }

                    th {
                        padding: 1ex;
                        height: 0.5in;
                        width: 1in;
                        text-align: left;
                        font-weight: normal;
                    }
            </style>
    </head>
    <body>
        <table>
            <thead>
                <tr>
                    <th>Sunday</th>
                    <th>Monday</th>
                    <th>Tuesday</th>
                    <th>Wednesday</th>
                    <th>Thursday</th>
                    <th>Friday</th>
                    <th>Saturday</th>
                </tr>
            </thead>
            <tbody>
~;

my $print_month_name = 1;

for ( my $w = 0; $w < $weeks; $w++ ) {
    $page .= qq~\n<tr>~;
	for ( my $d = 0; $d < 7; $d++ ) {
		$page .= qq~<td>~;
		$page .= $date->day;
		if ( $print_month_name ) {
			$page .= " " . $date->month_name;
		}
		$page .= qq~</td>~;
		$date->add( days => 1 );
        $print_month_name = $date->day == 1;
	}
	$page .= qq~</tr>~;
}

$page .= qq~
            </tbody>
        </table>
    </body>
</html>
~;

print $page;

# END
