#!/usr/bin/perl
# Copyright 2016, The MathWorks, Inc. 
# First author: Christian Bard  / The MathWorks company
#
# 1.0.1 -diff <first_analysis> <2nd_analysis>
# Polyspace Code Prover diff has not been tested
# 1.0.2 - It works also w/ Linux 

use strict;
use POSIX;
use File::Basename;
use Cwd;

my $tool = __FILE__;
$tool =~ s/^.*[\\\/]//;
$tool =~ s/(.*)\..*/\1/;
my $TOOLS_VERSION = "1.0.2";

#debug param 
my $isdebug = $ENV{'TOOLS_DEBUG_MODE'};
#$isdebug = 1;

# check parameters 
# extract any ".log" file from all <results>/ALL/ 
# Create a summary of results  in basic HTML file
 
# variables
my $results_dir = "";
my $results_dir_first = "";
my $results_dir_secnd = "";
my $opt = "";
my $isonlybf = 0; 
my $isdiff = 0; 
my $isannotations = 0;
my $annotations_file= "";
my $abs_annotations = "";

# Read command line options.
if ($#ARGV <0) {	    
    ShowHelpScreen(); 
}

while ($#ARGV >= 0) {
    my $param = shift(@ARGV);
    # no parameter at all 
    for ($param) {
	debug("PARAM: $param\n");
	
	/^-(h|help)$/ && do {
	    ShowHelpScreen();
	    last;
	};
	/^-bf$/ && do {
		$isonlybf = 1; 
		debug("arg: bf\n");
		last;
	};

	/^-diff$/ && do {
		$isdiff = 1; 
        if ($#ARGV < 2) {
                print STDERR "Fatal error: Missing argument for option $param.\n";
                exit 1;
            }
        $results_dir_first = shift(@ARGV);
	    if ($results_dir_first =~ /^-/ || $results_dir_first eq "") {
			print STDERR "Fatal error: Missing argument for option $results_dir_first.\n";
			exit 1;
	    }
		debug("First: $results_dir_first\n");
        $results_dir_secnd = shift(@ARGV);
	    if ($results_dir_secnd =~ /^-/ || $results_dir_secnd eq "") {
			print STDERR "Fatal error: Missing argument for option $results_dir_secnd.\n";
			exit 1;
	    }
		debug("Second: $results_dir_secnd\n");
		last;
	};

	/^-annotations$/ && do {
		$isannotations = 1; 
        if ($#ARGV < 2) {
                print STDERR "Fatal error: Missing argument for option $param.\n";
                exit 1;
            }
        $annotations_file = shift(@ARGV);
	    if ($annotations_file =~ /^-/ || $annotations_file eq "") {
			print STDERR "Fatal error: Missing argument for option $annotations_file.\n";
			exit 1;
	    }
		debug("annotations_file: $annotations_file\n");
 		last;
	};

	/^-rdir$/ && do {
	       # if ($#ARGV < 1) {
                # print STDERR "Fatal error: Missing argument for option $param.\n";
                # exit 1;
            # }
        $results_dir = shift(@ARGV);
	    if ($results_dir =~ /^-/ || $results_dir eq "") {
			print STDERR "Fatal error: Missing argument for option $results_dir.\n";
			exit 1;
	    }
		debug("$results_dir\n");
		last;
	};
	
	# default
	do {
	  print STDERR "Fatal error: unknown argument $param.\n";
	  ShowHelpScreen(); 
	};
	} # end for
}

#test if results directory contains necessary material
my $summary_file = "SummaryDiff.html";

my $osshell = GetOSShell(); # OS shell

my $here = Cwd::getcwd();
if ($osshell eq "linux") { $here =~ s/\\/\//g; } else { $here =~ s/\//\\/g;}
debug("here: $here\n");

#open HTML file and generate HTML Title /style
my $abs_results_first = toAbsolutePath($here,$results_dir_first);		
if ($osshell eq "linux") { $abs_results_first =~ s/\\/\//g; } else { $abs_results_first =~ s/\//\\/g;}
debug("dirname HTML FILE FIRST: $abs_results_first\n");

my $abs_results_secnd = toAbsolutePath($here,$results_dir_secnd);		
if ($osshell eq "linux") { $abs_results_secnd =~ s/\\/\//g; } else { $abs_results_secnd =~ s/\//\\/g;}
debug("dirname HTML FILE SECOND: $abs_results_secnd\n");

my $abs_results = toAbsolutePath($here,$results_dir);		
if ($osshell eq "linux") { $abs_results =~ s/\\/\//g; } else { $abs_results =~ s/\//\\/g;}
debug("dirname HTML FILE RES: $abs_results\n");

my $abs_annotations = toAbsolutePath($here,$annotations_file);		
if ($osshell eq "linux") { $abs_annotations =~ s/\\/\//g; } else { $abs_annotations =~ s/\//\\/g;}
debug("dirname HTML FILE ANNOTATIONS: $abs_annotations\n");

my $htmlresults = $abs_results . "\\" . $summary_file;
if ($osshell eq "linux") {
    $htmlresults =~ s/\\/\//g;
}
debug("HTML FILE: $htmlresults\n");

generateHTMLHeaderAndStyle($htmlresults);

# generate HTML Table header 
if (! open(outhtml, ">>$htmlresults")) {
	print STDERR "Fatal Error: Can not create file $htmlresults \n";
	exit 1;
}
binmode(outhtml);

if (!$isonlybf) {
# HTML Header
print outhtml<<EOF;
  <body bgcolor="#FFFFFF">
    <center>
      <h2>Polyspace Batch Results Summary</h2>
	  <BR>
	  <h1>Summary of results found in <a href=\"$abs_results\">$abs_results</a> sub-folder</h1>
	  <BR>
      <table id="Polyspace_summary">
        <thead>
          <tr>
            <th class="c1">name</td>
            <th class="c2">Green</td>
            <th class="c3">Orange</td>
            <th class="c4">OBAI/NIVL/ZDV</td>
            <th class="c5">First to review</td>
            <th class="c6">Red</td>
            <th class="c7">NTL/NTC</td>
            <th class="c8">UNR</td>
            <th class="c9">Selectivity</td>
            <th class="c10">Level</td>
            <th class="c11">Lang</td>
            <th class="c12">Line</td>
            <th class="c13">Time (s)</td>
            <th class="c14">Coding Rules</td>
			<th class="c15">Link to open results</td>
          </tr>
        </thead>
EOF
} else {
print outhtml<<EOF;
  <body bgcolor="#FFFFFF">
    <center>
      <h2>Polyspace Bug Finder Results Summary</h2>
	  <BR>
	  <h1>Summary of results found in <a href=\"$abs_results\">$abs_results</a> sub-folder</h1>
	  <BR>
      <table id="Polyspace_summary">
        <thead>
          <tr>
            <th class="c1">name</td>
EOF
if ($isannotations) {
print outhtml<<EOF;
            <th colspan=\"2\" class="c2"> # of defects </td>
EOF
} else {
print outhtml<<EOF;
            <th class="c2"> # of defects </td>
            <th class="c3"> </td>
EOF
}
print outhtml<<EOF;

            <th class="c4">Lang</td>
            <th class="c5">Files</td>
            <th class="c6">Line</td>
            <th class="c7">Time (s)</td>
EOF
if ($isannotations) {
print outhtml<<EOF;
            <th class="c8">Coding Rules</td>
EOF
} else { 
print outhtml<<EOF;
            <th class="c8">Coding Rules</td>
EOF
}
print outhtml<<EOF;
			<th class="c9">Link to open results</td>
          </tr>
        </thead>
EOF

}
# get the list of all .log files 
my @list_dotlog = ();
my %list_logs = ();
my $oslinux = 0;
if ($osshell eq "linux") {$oslinux = 1;}

%list_logs = FindPathsRec10a($abs_results_first,".psbf",$oslinux);
%list_logs = ( %list_logs, FindPathsRec10a($abs_results_secnd,".psbf",$oslinux));

# numerical sorting
@list_dotlog = sort { ($a =~ /(\d+)/)[0] <=> ($b =~ /(\d+)/)[0] } keys %list_logs;


# init total variable 
my		$tgreen = 0;
my		$torange= 0;
my		$tporange= 0;
my		$tred= 0;
my	    $tNTLNTC= 0;
my		$tgrey= 0;
my		$tpcent = 0;
my $tnb = 0;	
my $tlevel0 = 0; 
my $ttime = 0; # total analysis time
my $tline = 0; # nb line total
my $ttoopen = 0; # number of results that should be open (with a YES in last column)
#rules checker
my $tfiles = 0;


# Bug Finder count: nb of bf rules and nb of coding violations
my $tbf = 0;
my $trules = 0;
my $tnbannoations = 0;

foreach my $onedotlog (@list_dotlog) {
	next if ($onedotlog eq '.');
	next if ($onedotlog eq '..');
	debug("PATHtoRTE: - ONEDOTLOG: $onedotlog \n");
	my $lang = "";
	my $prog = "";
	my $level = 0; 
	my @color = (); 
	my $pathtoRTE = "";
	my $newlog = "";
	    if ($osshell eq "linux") {
			$newlog = $onedotlog . "/" . $list_logs{$onedotlog}[0];
	    } else {
			$newlog = $onedotlog . "\\" . $list_logs{$onedotlog}[0];
	    }

	    ($prog,$lang,$level,@color) = GetSummaryInfoInLog($newlog);

	    if ($osshell eq "linux") {
			$pathtoRTE = $onedotlog . "/" . $list_logs{$onedotlog}[1];
	    } else {
			$pathtoRTE = $onedotlog . "\\" . $list_logs{$onedotlog}[1];
	    }
		if ($osshell eq "linux") { 
			$pathtoRTE =~ s/\\/\//g; 
		} else { 
		   $pathtoRTE =~ s/\//\\/g; 
		   # replace for extra \\ by \ in absolute path name .. IE does not like it
		   $pathtoRTE =~ s/\\\\/\\/g; 
		}
	debug("PATHtoRTE: $pathtoRTE\n");
	my $bname = lbasename($onedotlog,0);
	
	print  "$tool - Processing $onedotlog sub-folder - $level \n";
	if ($level >= 0) {
        # generate a new HTML entry in table
		$tnb = $tnb+1;
		my $NTC_NTL = @color[6]+@color[7];
		my $grey = @color[8]+@color[4];
		print outhtml "<tr>\n";
        print outhtml "  <td class=\"c1\">$bname</td>\n";
        print outhtml "  <td class=\"c2\">@color[1]</td>\n";
        print outhtml "  <td class=\"c3\">@color[2]</td>\n";
        print outhtml "  <td class=\"c4\">@color[9]</td>\n";
        print outhtml "  <td class=\"c5\">@color[10]</td>\n";
        print outhtml "  <td class=\"c6\">@color[3]</td>\n";
        print outhtml "  <td class=\"c7\">$NTC_NTL</td>\n";
        print outhtml "  <td class=\"c8\">$grey</td>\n";
        print outhtml "  <td class=\"c9\">@color[5]%</td>\n";
        print outhtml "  <td class=\"c10\">$level</td>\n";
        print outhtml "  <td class=\"c11\">$lang</td>\n";
        print outhtml "  <td class=\"c12\">@color[11]</td>\n";
        print outhtml "  <td class=\"c13\">@color[12]</td>\n";
        print outhtml "  <td class=\"c14\">@color[13]</td>\n";
		print outhtml "  <td class=\"c15\"><a href=\"$pathtoRTE\">Open results</a></td>\n";
		print outhtml "</tr>\n";
		
		# DIFF total: 
		if ($tnb eq 1) {
			$tgreen   = @color[1] ;
			$torange  = @color[2] ;
			$tporange = @color[9] ;
			$tred     = @color[3];
			$tNTLNTC  = $NTC_NTL;
			$tgrey    = $grey;
			$tlevel0  = @color[10]
		} else {
			$tgreen   -= @color[1] ;
			$torange  -= @color[2] ;
			$tporange -= @color[9] ;
			$tred     -= @color[3];
			$tNTLNTC  -= $NTC_NTL;
			$tgrey    -= $grey;
			$trules   -= @color[13];
			$tlevel0  -= @color[10]

		}
		
	} else {
		print outhtml "<tr>\n";
        print outhtml "  <td>$bname</td>\n";
        if ($level == -2) { # Polyspace Bug Finder 
			if ($isonlybf) {
				$tnb = $tnb+1;
				# if ($tnb eq 1) { $tbf = @color[15]; } else { $tbf = @color[15] - $tbf;}
				$tbf = @color[15];
				debug(" NB total defects $tnb: $tbf\n");
				print outhtml "  <td colspan=\"2\" class=\"c2\">@color[15]</td>\n";
				# print outhtml "  <td class=\"c3\"> </td>\n";
				print outhtml "  <th class=\"c4\">$lang</td>\n";
				print outhtml "  <th class=\"c5\">@color[16]</td>\n";
				print outhtml "  <th class=\"c6\">@color[11]</td>\n";
				print outhtml "  <th class=\"c7\">@color[12]</td>\n";
				print outhtml "  <td class=\"c8\">@color[13]</td>\n";
				print outhtml "  <th class=\"c9\"><a href=\"$pathtoRTE\">Open results</a></td>\n";
			
			} else { 
				# Not Polyspace Bug Finder results nor Polyspace Code Prover results
				print outhtml "  <td colspan=\"8\">$prog</td>\n";
				print outhtml "  <td>Bug Finder</td>\n";
				print outhtml "  <td>$lang</td>\n";
				print outhtml "  <td>@color[11]</td>\n";
				print outhtml "  <td>@color[12]</td>\n";
				print outhtml "  <td class=\"c14\">@color[13]</td>\n";
				print outhtml "  <td class=\"c15\"><a href=\"$pathtoRTE\">Open results</a></td>\n";
			}
        } else {
		    # generate a new HTML entry in table - failed of Polyspace Bug Finder 
		    print outhtml "  <td colspan=\"8\"> </td>\n";
			if ($level eq -3) {
				print outhtml "  <td>On remote</td>\n";
			} else { 
				print outhtml "  <td>Failed</td>\n";
			}
			print outhtml "  <td>$lang</td>\n";
			print outhtml "  <td> </td>\n";
			print outhtml "  <td> </td>\n";
			print outhtml "  <td class=\"c14\">@color[13]</td>\n";
			$pathtoRTE = $newlog;
			if ($osshell eq "linux") { 
				$pathtoRTE =~ s/\\/\//g; 
			} else { 
				$pathtoRTE =~ s/\//\\/g; 
				$pathtoRTE =~ s/\\\\/\\/g; 
			}
			print outhtml "  <td class=\"c15\"><a href=\"$pathtoRTE\">Log file</a></td>\n";
        }
		print outhtml "</tr>\n";

	}
	# nb coding rules 
	# if ($tnb eq 1) { $trules = @color[13]; } else { $trules = @color[13] - $trules;}
	$trules = @color[13];
	debug(" NB total defects: $tnb -- $trules\n");
} # foreach 

		my $nbannotations = 0;
		my $nbrulesannot = 0;
		my $nbnewrules = 0;
		my $nbnewdefects = 0;
		if ($isannotations) {
			($nbannotations,$nbrulesannot,$nbnewdefects,$nbnewrules) = GetAnnotations($abs_annotations);
			debug("GETANNOTATIONS: $nbannotations $nbrulesannot $nbnewdefects $nbnewrules\n");
		}

# print total at the end:
		if (!$isonlybf) {
			print outhtml "<tr>\n";
			print outhtml "  <td class=\"c1\">DIFF:</td>\n";
			print outhtml "  <td class=\"c2\">$tgreen</td>\n";
			print outhtml "  <td class=\"c3\">$torange</td>\n";
			print outhtml "  <td class=\"c4\">$tporange</td>\n";
			print outhtml "  <td class=\"c5\">$tlevel0</td>\n";
			print outhtml "  <td class=\"c6\">$tred</td>\n";
			print outhtml "  <td class=\"c7\">$tNTLNTC</td>\n";
			print outhtml "  <td class=\"c8\">$tgrey</td>\n";
			print outhtml "  <td class=\"c9\"> </td>\n";
			print outhtml "  <td class=\"c10\"> </td>\n";
			print outhtml "  <td class=\"c11\"> </td>\n";
			print outhtml "  <td class=\"c12\"> </td>\n";
			print outhtml "  <td class=\"c13\"> </td>\n";
			print outhtml "  <td class=\"c14\">$trules</td>\n";
			print outhtml "  <td class=\"c15\"> </td>\n";
			print outhtml "</tr>\n";
		} else { 
			print outhtml "<tr>\n";
			print outhtml "  <td class=\"c1\"> # to review </td>\n";
			if ($isannotations) {
				# my $tdefects = $tbf; 
				if ($nbannotations > 0) { $tbf = $tbf-$nbannotations; }
				if ($nbnewdefects != 0) {
						print outhtml "  <th class=\"c2\" colspan=\"2\">$tbf (new: $nbnewdefects)</th>\n";				
				} else {
					if ($nbannotations eq 0) {
						print outhtml "  <th class=\"c2\" colspan=\"2\">$tbf</th>\n";
					} else {
						print outhtml "  <th class=\"c2\" colspan=\"2\">$tbf (commented: $nbannotations)</th>\n";
					}
				}
			} else {
				print outhtml "  <td colspan=\"2\" class=\"c2\">$tbf</td>\n";
				# print outhtml "  <td class=\"c3\"> </td>\n";
			}
			print outhtml "  <td class=\"c4\"> </td>\n";
			print outhtml "  <td class=\"c5\"> </td>\n";
			print outhtml "  <td class=\"c6\"> </td>\n";
			print outhtml "  <td class=\"c7\"> </td>\n";
			if ($isannotations) {
				if ($nbrulesannot > 0) { $trules = $trules-$nbrulesannot; }
				if ($nbnewrules != 0) {
					print outhtml "  <td class=\"c8\">$trules (new: $nbnewrules)</td>\n";
				} else {
					if ($nbrulesannot eq 0) {
						print outhtml "  <td class=\"c8\">$trules</td>\n";
					} else {
						print outhtml "  <td class=\"c8\">$trules (commented: $nbrulesannot)</td>\n";
					}				
				}
			}
			print outhtml "  <td class=\"c9\"> </td>\n";
			print outhtml "</tr>\n";
		}

# HTML end of file
my $ltime = GetLocalTime();

print outhtml <<EOF;
</table>
</center>
    <script type="text/javascript">
      var tbl2sort = new SortTable(document.getElementById('Polyspace_summary'));
    </script>
<br>
Results summary generated at $ltime </body>
</html>
EOF

close(outhtml);

#################
# Sub procedures 
#################

sub ShowHelpScreen
{
  print <<EOF;
NAME
    $tool

SYNOPSIS
	$tool
	    [-h]|[-help]
        -results-dir <dir>

OPTIONS
	-h or -help
	    Display this help - version $TOOLS_VERSION.
	
	-bf 
		Seek only Polyspace Bug Finder results. 
		
	-results-dir <dir>
	    From absolute folder <dir> $tool seeks in a recursive way. 
				
DESCRIPTION
	The scrip summarize results in all folder and sub-folder from absolute <dir> path.
	The summmary is a HTML table giving number of checks by color, number of NTC/NTL, 
	number of unreachable blocks (UNR) or "failed" if no results are available.
	a HTML PolyspaceSummary<basename(<dir>)>.html file contains the summary of all the results 
	found and put in folder <dir>.
	$tool only works using Perl (Perl is installed in Polyspace product).

USAGE ADVICE
	Please send your remarks and questions to the author: Christian.Bard\@mathworks.fr
	
EOF
  exit 0;
}

# localtime in a string like that: 10:12:42, Wed Dec 28, 2005
sub GetLocalTime
{
	my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
	my $year = 1900 + $yearOffset;
	my $theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
	return($theTime);
} 

# mkdir_p(dir name) : Creates a directory and all its parents (if needed).
sub mkdir_p
{
    my ($dir) = @_;
    debug ("mkdir_p: Creating directory $dir.\n");

    my $err_code = 1;
    if ((! -d $dir) && (! mkdir $dir)) {
	my $dir2 = $dir;
	$dir2 =~ s/^(.*)[\\\/].*$/\1/;
	$err_code = mkdir_p($dir2);
	if ($err_code) {
	    $err_code = mkdir $dir;
	}
    }
    return $err_code; 
}

sub GetAnnotations
{
  my ($annfile) = @_;
 
 # local variables 
  my $defectanntotal = 0;
  my $rulesanntotal = 0;
  my $isdefect = 0;
  my $ismisra = 0;
  my $newrule = 0;
  my $newdefect = 0;

  if (! -e $annfile) {
    print STDERR "Warning: File \"$annfile\" does not exist.\n";
    return (0,0,0,0);
  }
  if (! open(infann, $annfile)) {
    print STDERR "Warning: Can not open file \"$annfile\" for reading.\n";
    return (0,0,0,0);
  }
  binmode(infann);
  my $annline = "";
  while (chomp($annline = <infann>)) {
		for ($annline) {

		/MISRA C:2012 \d+\.\d+ not found in the old results/ && do {
			$newrule += 1;
			last;
		};
		/MISRA-C:2004 \d+\.\d+ not found in the old results/ && do {
			$newrule += 1;
			 last;
		};
		
		/MISRA C\+\+ \d+-\d+-\d+ not found in the old results/ && do {
			$newrule += 1;
			 last;
		};
		/JSF \d+ not found in the old results/ && do {
				$newrule += 1;
			    last;
		};
		
		/Defect \w+ not found in the old results/ && do {
				$newdefect += 1;
			    last;
		};

		/Diff statistics for Defect results/ && do {
				$isdefect = 1;
				$ismisra = 0;
			last;
			};
			
			/Diff statistics for MISRA C\+\+ results/ && do {
				$isdefect = 0;
				$ismisra = 1;			
			last;
			};

			/Diff statistics for MISRA C results/ && do {
				$isdefect = 0;
				$ismisra = 1;			
			last;
			};

			/Diff statistics for JSF results/ && do {
				$isdefect = 0;
				$ismisra = 1;			
			last;
			};
			
			
			# Number of fully imported results comments
			/Number of fully imported results comments\s+:\s*(\d+)/ && do {
			if ($isdefect) {
					$defectanntotal += $1;
				} else {
					$rulesanntotal += $1;
				}
			last;
			};
			/Number of matched results with a comment coming from source code annotation:\s+(\d+)/ && do {
			if ($isdefect) {
					$defectanntotal += $1;
				} else {
					$rulesanntotal += $1;
				}
			last;
			};
			
			/Number of fully imported results comments\s+:\s+(\d+)/ && do {
			if ($isdefect) {
					$defectanntotal += $1;
				} else {
					$rulesanntotal += $1;
				}
			last;
			};
		}
	}
  close(infann);
  return ($defectanntotal,$rulesanntotal,$newdefect,$newrule);	
}

sub GetSummaryInfoInLog
{
  my ($srcfile) = @_;
 
 # local variables 
  my $prog = "";
  my $lang = "";
  my $levelsummary = -1;
  my $total = 0;
  my $isadalang = 0;
  my @finding = ();

  if (! -e $srcfile) {
    print STDERR "Warning: File \"$srcfile\" does not exist.\n";
	$prog = "File not found";
    return ($prog,$lang,$levelsummary,@finding);
  }
  if (! open(infptr, $srcfile)) {
    print STDERR "Warning: Can not open file \"$srcfile\" for reading.\n";
	$prog = "Impossible to read";
    return ($prog,$lang,$levelsummary,@finding);
  }
  binmode(infptr);
  my $line = "";
  my $total = 0;
  my $isadalang = 0;
  @finding = ();
  @finding[13] = 0;
  @finding[15] = 0;
  while (chomp($line = <infptr>)) {
    for ($line) {
	
	# -prog 
	/^-prog=(\w+)/ && do {
		$prog = $1;
		debug("PROG: $prog\n");
		last;
	};
	
	# for ADA	 *** Level X Software Safety Analysis done
    /^\*\*\*\s+Level (\d+) .*? done/ && do {
		$levelsummary = $1;
		debug("LEVEL: $levelsummary\n");
		last;
    };
    /^\*\*\* .*? Level (\d+) done/ && do {
		$levelsummary = $1;
		debug("LEVEL: $levelsummary\n");
		last;
    };
	#  - OBAI    => Green :   882, Orange :    72, Red :     0, Gray :    21   (93%)
    /OBAI\s+=\>\sGreen\s:\s+(\d+),\sOrange\s:\s+(\d+),\sRed/  && do {
		# $total = $1;
		debug( "OBAI Find before @finding[9]\n");
		@finding[9] = $2 + @finding[9];
		debug( "Find after Orange NIV/OBAI  @finding[9]\n");
		last;
    };
   /NIVL\s+=\>\sGreen\s:\s+(\d+),\sOrange\s:\s+(\d+),\sRed/  && do {
		# $total = $1;
		debug( "NIVL Find before @finding[9]\n");
		@finding[9] = $2 + @finding[9];
		debug( "Find after Orange NIV/OBAI  @finding[9]\n");
		last;
    };
   /ZDV\s+=\>\sGreen\s:\s+(\d+),\sOrange\s:\s+(\d+),\sRed/  && do {
		# $total = $1;
		debug( "ZDV Find before @finding[9]\n");
		@finding[9] = $2 + @finding[9];
		debug( "Find after Orange NIV/OBAI  @finding[9]\n");
		last;
    };
	
	/Number\s+of\s+contextual\s+findings\s+:\s+(\d+)/ && do {
		# $total = $1;
		debug( "level0 before @finding[10]\n");
		@finding[10] = $1 + @finding[10];
		debug( "Find after level0  @finding[10]\n");
		last;
	
	};
	
	# since R2012b 
	/Number\s+of\s+oranges\s+that\s+are\s+bounded\s+input\s+issues\s+:\s+(\d+)/ && do {
		# $total = $1;
		debug( "level0 before bounded @finding[10]\n");
		@finding[10] = $1 + @finding[10];
		debug( "Find after bounded level0  @finding[10]\n");
		last;	
	};
	# does not count unbounded input values. 
	#/Number\s+of\s+oranges\s+that\s+are\s+related\s+to\s+unbounded\s+input\s+values\s*:\s+(\d+)/ && do {
		# $total = $1;
	#	debug( "level0 before unbounded @finding[10]\n");
	#	@finding[10] = $1 + @finding[10];
	#	debug( "Find after unbounded level0  @finding[10]\n");
	#	last;	
	#};
	/Number\s+of\s+orange\s+checks\s+that\s+are\s+path\-related\s+issues\s+:\s+(\d+)/ && do {
		debug( "level0 before path related @finding[10]\n");
		@finding[10] = $1 + @finding[10];
		debug( "Find after path related level0  @finding[10]\n");
		last;
	};
	
	/Number\s+of\s+oranges\s+that\s+are\s+path-related\s+issues\s+:\s+(\d+)/ && do {
		# $total = $1;
		debug( "level0 before path related @finding[10]\n");
		@finding[10] = $1 + @finding[10];
		debug( "Find after path related level0  @finding[10]\n");
		last;	
	};
	
	
	# before R2011b
	# TOTAL:    => Green :   882, Orange :    72, Red :     0, Gray :    21   (93%)
    /^(TOTAL:\s+=\>\sGreen :\s+(\d+), Orange :\s+(\d+), Red :\s+(\d+), Gray :\s+(\d+)\s+\((\d+)%\))/  && do {
		# $total = $1;
		@finding[1] = $2;
		@finding[2] = $3;
		@finding[3] = $4;
		@finding[4] = $5;
		@finding[5] = $6;
		last;
    };
	
	# Since R2011b
    # TOTAL:    => Green :    22, Orange :     0, Red :     1   (100%)
	/^(TOTAL:\s+=\>\sGreen :\s+(\d+), Orange :\s+(\d+), Red :\s+(\d+)\s+\((\d+)%\))/  && do {
		# $total = $1;
		@finding[1] = $2;
		@finding[2] = $3;
		@finding[3] = $4;
		# @finding[4]
		@finding[5] = $5;
		last;
    };
	
	# Number of NTL : 2
    /^Number of NTL :\s+(\d+)/  && do {
		@finding[6] = $1;
		last;
	};
	# Number of NTC : 3
    /^Number of NTC :\s+(\d+)/  && do {
		@finding[7] = $1;
		last;
	};
	# Number of UNR : 4
    /^Number of UNR :\s+(\d+)/  && do {
		@finding[8] = $1;
		last;
	};
    /^-lang=(.+)/ && do {
      $lang = $1; 
      debug("LANG: $lang\n");
	  if (($lang eq "ADA") or ($lang eq "ADA95")) { $isadalang = 1;}
      last;
    };
    /^\* statistics :/ && do {
		if ($isadalang) {
			@finding[1] = 0; @finding[2] = 0; @finding[3] = 0; @finding[4] = 0; @finding[6] = 0;
			@finding[5] = 0; @finding[7] = 0; @finding[8] = 0; @finding[9] = 0; @finding[10] = 0;
		}
		last;
	};
    # sum reinitialised for each level (we want summ of Oranges that would be green of last level) only
	/Checks\s+statistics:/ && do {
		@finding[9] = 0;
		@finding[10] = 0;
		debug( "NEW statistics Orange NIV/OBAI  @finding[9] @finding[10]\n");
		last;
	};
    /Total number of defects:\s+(\d+)/ && do {
		# Polyspace bug finder
		$levelsummary = -2;
		debug("LEVEL: $levelsummary\n");
		if ($isonlybf) {$prog="$1"; @finding[15] = $1;} else { $prog = "Number of defects: $1";}
		last;
	};
	
	# nb files 
	/Number of files\s+:\s+(\d+)/ && do {
			@finding[16] = $1;
			last;
	}; 
	
	# nb lines 
	/Number of lines without comments\s+:\s+(\d+)/ && do {
			@finding[11] = $1;
			last;
	}; 
	
	# time 
	/User time for polyspace-code-prover-nodesktop:.*?\((\d*\.*\d*)real/ && do {
			@finding[12] = $1;
			last;
	}; 
	
	# time 
	/User time for function:.*?\((\d*\.*\d*)real/ && do {
			@finding[12] = $1;
			last;
	}; 
	# time 
	/User time for polyspace-bug-finder-nodesktop:.*?\((\d*\.*\d*)real/ && do {
			@finding[12] = $1;
			last;
	}; 
	# time 
	/User time for polyspace-c:.*?\((\d*\.*\d*)real/ && do {
			@finding[12] = $1;
			last;
	}; 
	# time 
	/User time for polyspace-cpp:.*?\((\d*\.*\d*)real/ && do {
			@finding[12] = $1;
			last;
	}; 

	# time 
	/User time for polyspace-ada:.*?\((\d*\.*\d*)real/ && do {
			@finding[12] = $1;
			last;
	}; 
	
	
	#JSF
	/AV Rule \d+ violated (\d+) time/ && do {
		@finding[13] += $1;		
		last;
	};
	
	#MISRA C++
	/rule \d+-\d+-\d+ violated (\d+) time/ && do {
			@finding[13] += $1;
			debug("MISRA C++: @finding[13]\n");
			last;
	};
	# for MISRA Violations advisory:
	# 1 advisory rule(s) violated
	/(\d+)\s+advisory rule violated/ && do {
			@finding[13] += $1;
			last;
	}; 
	/(\d+)\s+advisory rules violated/ && do {
			@finding[13] += $1;
			last;
	}; 
	# for MISRA Violations required:
	/(\d+)\s+required rules violated/ && do {
			@finding[13] += $1;
			last;
	}; 
	/(\d+)\s+required rule violated/ && do {
			@finding[13] += $1;
			last;
	}; 
	
	# For ADA
	#{UNR    =>  Green : 0,  Orange : 0,  Red : 0,  Black : 5 }
	# ...  {NTL    =>  Green : 0,  Orange : 0,  Red : 2,  Black : 0 }
	/^\{(\w+)\s+=\>\s+Green :\s+(\d+),\s+Orange :\s+(\d+),\s+Red :\s+(\d+),\s+Black :\s+(\d+)\s+\}/  && do {
		debug( "debug $line\n");
		if ($isadalang) {
		    my $red = $4;
			my $black = $5;
			for ($1) {
			/UNP/ && do {
				# count nothing 
				last;	
			};
			/UNR/ && do {
				@finding[8] += $black;			
				debug("debug UNR @finding[8]\n");
				last;	
			};
			/NTC/ && do {
				@finding[7] += $red;
				debug("debug NTC @finding[7]\n");
 				last;
			};
			/NTL/ && do {
				@finding[6] += $red;
				debug( "debug NTL @finding[6]\n");
				last;
			};
			@finding[1] += $2;
			@finding[2] += $3;
			@finding[3] += $4;
			@finding[4] += $5;
			debug("debug green  @finding[1] orange @finding[2] red @finding[3] balck @finding[4] \n");
			}
		} 
		last;
    };
	} # end for 
  }   # end while   
	close(infptr);
	#calculate selectivity iif ADA lang
	if ($isadalang) {
		$total = @finding[8] + @finding[1] + @finding[2]  + @finding[3]  + @finding[4]  + @finding[6]  +@finding[7] ;
		@finding[5] = ceil((($total - @finding[2]) / $total)*100);
		debug( "Selectivity  @finding[5]\n");
	}
	debug( "Orange NIV/OBAI  @finding[13] @finding[14]\n");
	return ($prog,$lang,$levelsummary,@finding);
}

# Find subfolders containing a specific file
# $basedir is folder
# $name is researched file name
# ostype = 1 for Linux ; 0 for Windows
sub FindPathsRec10a
{
    my ($basedir, $name, $ostype) = @_;
    my %list_logs = ();
	
    if (opendir(dirhandle, $basedir)) {
		my @items = readdir(dirhandle);
		closedir(dirhandle);
		foreach my $item (@items) {
			next if ($item eq '.' || $item eq '..');
			next if ($item =~ /intermediate_results/);
			next if ($item =~ /comments_bak/);
			next if ($item =~ /\.settings/); 
			next if ($item =~ /\.status/); 
			next if ($item =~ /Polyspace\.remote\.log/); 
			
			my $baseitem = "$basedir\\$item";
			if ($ostype) { 
			    $baseitem =~ s/\\/\//g;
			}
			if (-d "$baseitem") {
				%list_logs = ( %list_logs, FindPathsRec10a("$baseitem",$name,$ostype) );
			} elsif ($item =~ /$name$/) { # only $name suffix 
					debug("FindFilesRec10a: $basedir -- $item\n");
					#need to open file and get relation to log file name 
					if (! open(infrtefile, "$baseitem")) {
						print STDERR "Fatal Error: Can not open file \"$baseitem\" for reading.\n";
						print STDERR "You may mix results before and after R2009b\n";
						exit 1;
					}
					binmode(infrtefile);
					my $log = "";
					my $islogfound = 0;
					my $line = "";
					while (chomp($line = <infrtefile>)) {
						for ($line) {
							/^log=(.+)/ && do {
								$log = $1; 
								debug("LOG: $log\n");
								$islogfound = 1;
								last;
							};
						}
					}
					close(infrtefile);
					if ($islogfound) {
						$list_logs{$basedir} = [$log,$item];
					} 
					# else {
						# $list_logs{$basedir} = ["ALL/.log",$item];
					# }
				} elsif ($item =~ /\.log$/) { # only $name suffix 
						debug("FindPathsRec10a: $basedir -- $item\n");
						my $isresults = "$basedir\\ps_results$name";
						if ($ostype) { 
							$isresults =~ s/\\/\//g;
						}
						if (-f "$isresults") {
							# check that ps_results.* has same modified date than *.log file 
							my $last_mod_time_log = (stat ($item))[9];
							my $last_mod_time_psdatabase = (stat ($isresults))[9];
							debug("FindPathsRec10a time: $last_mod_time_log -- $last_mod_time_log\n");
							if ($last_mod_time_log eq $last_mod_time_log) {
								$list_logs{$basedir} = [$item,"ps_results$name"];	
								debug("FindPathsRec10a in list_logs : $item -- $basedir\n");
							}
						}
				}
			}
    }
    return %list_logs;
}

sub FindPathsRecDatabase
{
    my ($basedir, $name, $ostype) = @_;
    my %list_logs = ();
	
    if (opendir(dirhandle, $basedir)) {
		my @items = readdir(dirhandle);
		closedir(dirhandle);
		foreach my $item (@items) {
			next if ($item eq '.' || $item eq '..');
			next if ($item =~ /intermediate_results/);
			next if ($item =~ /comments_bak/);
			next if ($item =~ /\.s*/); 
			
			my $baseitem = "$basedir\\$item";
			if ($ostype) { 
			    $baseitem =~ s/\\/\//g;
			}
			if (-d "$baseitem") {
				%list_logs = ( %list_logs, FindPathsRecDatabase($baseitem,$name,$ostype) );
			} elsif ($item =~ /\.log$/) { # only $name suffix 
						debug("FindPathsRecDatabase: $basedir -- $item\n");
						my $isresults = "$basedir\\ps_results\.$name";
						if ($ostype) { 
							$isresults =~ s/\\/\//g;
						}
						if (-f "$isresults") {
							
							# check that ps_results.* has same modified date than *.log file 
							my $last_mod_time_log = (stat ($item))[9];
							my $last_mod_time_psdatabase = (stat ($isresults))[9];
							if ($last_mod_time_log eq $last_mod_time_log) {
								$list_logs{$basedir} = [$item,$item];	
								debug("FindPathsRecDatabase in list_logs : $item -- $basedir\n");
							}
						}
			}
		}
    }
    return %list_logs;
}


sub lbasename
{
  my ($path, $ext) = @_;
  $path =~ s/(.)[\\\/]$/\1/;
  $path =~ s/^.*?(.[^\\\/]*)$/\1/;
  $path =~ s/^[\\\/](.)/\1/;
  if ($ext) {
    $ext =~ s/\./\\\./g;
    $ext =~ s/\*/\.\*/g;
    $ext =~ s/\?/\./g;
    $path =~ s/^(.*)${ext}$/\1/;
    debug("basename: ext $ext\n");	
  }
  debug("basename: path $path\n");
  return $path;
}


sub debug
{
  my ($msg) = @_;
  if ($isdebug) {
    print "$tool- debug - $msg";
  }
}


sub generateHTMLHeaderAndStyle
{
	my ($file) = @_;

	if (! open(outhtml, ">$file")) {
		print STDERR "Fatal Error: Can not create file $file in generateHTMLHeaderAndStyle \n";
		exit 1;
	}
	binmode(outhtml);
	if (!$isonlybf) { 

	print outhtml<<EOF;
<html>
  <head>
  <title>PolySpace Batch Results Summary</title>
     <script type="text/javascript">
      //
      // This file and its contents are the property of The MathWorks, Inc.
      // 
      // This file contains confidential proprietary information.
      // The reproduction, distribution, utilization or the communication
      // of this file or any part thereof is strictly prohibited.
      // Offenders will be held liable for the payment of damages.
      //
      // Copyright 1999-2011 The MathWorks, Inc.
      //
      
      function SortTable(tableElement)
      {
          // ***********************************************************************
          // functions part
          // ***********************************************************************
      
          // put table elements into an array: elements are taken within the selected
          // tagname <tbody></tbody> or <thead></thead>
          this.staticRows = tableElement.getElementsByTagName('thead'); // create the static array: first row which is not sorted
          this.dynamicRows = tableElement.getElementsByTagName('tbody'); // create the dynamic array: rows which are sorted
       
          // get cell content
          this.getCellContent = function(element) {
      	if (element == null)
      	    return '';
              if (typeof(element.innerText) != 'undefined')
                  return element.innerText;        // OK for IE but not FireFox
              if (typeof(element.textContent) != 'undefined')
                  return element.textContent;    // to support FireFox
              if (typeof(element.innerHTML) == 'string')
                  return element.innerHTML.replace(/<[^<>]+>/g,'');
          }
       
          // get parent element
          this.getParent = function(element, pTagName) {
              if (element == null)
                  return null;
              else if (element.nodeType == 1 && element.tagName.toLowerCase() == pTagName.toLowerCase())
                  return element;
              else
                  return this.getParent(element.parentNode, pTagName);
          }
      
          // Comparison function used to sort the rows.
          this.compareElements = function(Element1, Element2) {
              number1 = parseFloat(myObject.getCellContent(Element1.cells[myObject.columnIndex]));
              number2 = parseFloat(myObject.getCellContent(Element2.cells[myObject.columnIndex]));
              if (isNaN(number1)) {
                  if (isNaN(number2)) {
                      // Non-numeric elements are compared lexically not using case sensitive.
                      lowerElement1 = myObject.getCellContent(Element1.cells[myObject.columnIndex]).toLowerCase();
                      lowerElement2 = myObject.getCellContent(Element2.cells[myObject.columnIndex]).toLowerCase();
                      if (lowerElement1 == lowerElement2)
                          return 0;
                      else if (lowerElement1 < lowerElement2)
                          return -1;
                      else
                          return 1;
                  } else {
                      // A non-numeric element is assumed to be smaller than a numeric element.
                      return -1;
                  }
              } else if (isNaN(number2))
                  return 1;
              else {
                  // Numeric elements are compared numerically.
                  return number1 - number2;
              }
          }
       
          // sort the elements
          this.sort = function(cell) {
              this.columnIndex = cell.cellIndex;
       
              var sortedRows = new Array();
              for (j = 0; j < this.dynamicRows[0].rows.length; j++) {
                  sortedRows[j] = this.dynamicRows[0].rows[j];
              }
       
              sortedRows.sort(this.compareElements);
              
              // set the sort order
              if (cell.getAttribute("sortdir") == 'down') {
                  sortedRows.reverse();
                  cell.setAttribute('sortdir', 'up');
              } else {
                  cell.setAttribute('sortdir', 'down');
              }
              
              // display new sorted table
              for (i = 0; i < sortedRows.length; i++) {
                  this.dynamicRows[0].appendChild(sortedRows[i]);
              }
       
          }
       
          // ***********************************************************************
          // main part
          // ***********************************************************************
       
          // define variables
          var myObject = this;
          var sortLink = this.staticRows;
       
          // main actions
          if (! (this.dynamicRows && this.dynamicRows[0].rows && this.dynamicRows[0].rows.length > 0))
              return;
       
          if (sortLink && sortLink[0].rows && sortLink[0].rows.length > 0) {
              var sortRow = sortLink[0].rows[0];
          } else {
              return;
          }
       
          for (var i=0; i < sortRow.cells.length; i++) {
              sortRow.cells[i].sortedTable = this;
              sortRow.cells[i].onclick = function() {
                  this.sortedTable.sort(this);
                  return false;
              }
          }
      }
    </script>
    <style type="text/css">
/*********** Reset *************/
:focus {
	outline: 0;
}
p, ul, ol {
	margin-top:0px;
}
img {
	border:none;
}
/*Base Styles*/
body, td, th {
	font: 10pt Arial;
	margin-top:7px;
}
body {
	background-color: #fff;
	color: #000;
}
h1 {
	font-size: 16pt;
	color: #2E5191;
	margin-top:0;
}
h2 {
	font-size: 12pt;
	color: #324678;
	padding-left:0.25em;
	padding-bottom: 0.10em;
	margin-top:0;
	margin-bottom: 0.25em;
	background: #F5F5F5;
	border-bottom:1px solid #aaa
}
h3 {
	color: #c86a02;
	font-size: 10pt;
	margin-top: 0;
	margin-bottom: 0;
}
h4 {
	color:maroon;
	font-size: 9pt;
	margin-top:1em;
	margin-bottom:0;
}
h5 {
	color:black;
	font-size: 9pt;
	margin-top:1em;
	margin-bottom:0;
}

a {
	text-decoration: none;
	color: #002bb8;
	background: none;
}
a:link {
	color: #002bb8;
	text-decoration:none;
}
a:visited {
	color: #5a3696;
	text-decoration:none;
}
a:active {
	color: #faa700;
}
a:hover {
	color: #5a3696;
	text-decoration: underline;
}
/*Tables*/
th {
	color: white;
	font-weight:bold;
	background-color: #324678;
	border: #aaa;
	text-align:center;
}
th a:link, th a:visited {
	color:white
}

/* Sortable tables */
table.sortable a.sortheader {
	color:white;
	font-weight: bold;
	text-decoration: none;
	display: block;
}
table.sortable span.sortarrow {
	color: orange;
	text-decoration: none;
}

/* Topnav */
/* Links */

.globalnav a:link,  .globalnav a:visited, .globalnav a:hover {
	font-weight:bold;
	text-decoration:none;
}
.topnav1 a:link, .topnav1 a:visited {
	font-size:10pt;
	color:white
}
.topnav2 a:link, .topnav2 a:visited {
	font-size:8pt;
	color:black
}
.activenavcell a:link, .activenavcell a:visited, .activenavcell a:hover {
	color:white;
}

.topnav1 td, .topnav2 td {
	padding-left:10px;
	padding-right:10px;
}
.topnav1 td {
	padding:3px;
	border-bottom: 1px solid #B0B0B0;
	border-left:1px solid #B0B0B0;
}
.topnav2 td {
	border-right: 1px solid #B0B0B0;
	border-bottom: 1px solid #B0B0B0;
	cursor:hand
}

/*This highlights the topnav1 cell the same as the topnav2 cells */
.topnav1 .activenavcell {
	background-color: maroon;
}
.topnav2 .activenavcell {
	background-color: maroon;
}

/* Cell Backgrounds*/
.topnav1 td {
	background-color: #324678;
}
.topnav2 td {
	background-color: whitesmoke;
}

/*BreadCrumbs*/
#bcrumbs {
	font-size:9pt;
	border-bottom:1px solid lightgrey;
	background: whitesmoke;
}
#bcrumbs a {
	font-size:9pt;
	font-weight:normal;
}
#bcrumbs a:hover {
	text-decoration:underline;
}

/*Popup Menus*/
.menu_lay {
	display:none;
	background-color:#F2F4F8;
	border:1px solid #254987;
	padding:3px;
	white-space: nowrap;
	position:absolute;
}
.menu_lay a {
	text-decoration: none;
	font-weight:normal;
	text-indent: 5px;
}
.menu_lay a:hover {
	text-decoration: none;
}
.menuitem {
	border:1px solid #F2F4F8;
	position:relative;
	width:auto;
}
.menuitem_hover {
	border:1px solid gray;
	background-color:#E3E7F7;
	cursor:hand;
}

/*Mainbody*/
div#mainbody {
	width:740px;
	margin-left: 5px;
}

/*TableTop1*/
.tabletop1 .title {
	color: #244786;
	font-size: 12pt;
	font-weight: bold;
	border-bottom: 1px solid gray;
}
.sectbox1  {
	background-color:#E4E8F1;
	padding-left:5px;
}
.tabletop1 .rtext {
	text-align : right;
	border-bottom: 1px solid gray;
	padding-right: 5px;
}

/*GlobalFooter*/
#globalfooter {
	clear:both;
	float:left;
	width:900px;
	margin-top:20px;
	border-top: 1px solid #324678;
	font-style: italic;
}
#globalfooter a {
	font-weight:bold;
}
#dblclick_footer {
	float:left
}
#contact_footer {
	float:right;
	clear:right;
	text-align:right;
}
#lastmod_footer {
	font-style: normal;
	font-size:8pt;
	clear:right;
	text-align:right;
}

/*Should go away someday - these are legacy hangovers*/
#footertable {
	clear:both;
}
#footertable td {
	border-top: 1px solid #006599;
}

/*Team Homepage Template*/
#header_graphic {
	margin-bottom:20px;
}
#open_area {
	clear:left;
}

/*listcol*/
div.listcol {
	float: left;
	 width: 680px;
}
/*Fix for mozilla ul equalizer - I set to zero and then add the matching bottom pad*/
html>body .listcol ul {
	margin-top: 0;
	padding: 0;
	margin-bottom: 15px;
}
html>body div.row {
	margin-top: 20px;
	padding-top:20px;
}
div.listcol ul {
	list-style-type: none;
	margin-bottom: 15px;
	margin-left: 0
}
div.listcol div.col {
	width: 48%;
	float: left;
}
div.row {
	clear: left;
	margin-bottom:20px;
}
div.spacer {
	float:left;
	width:25px;
	height:10px;
}

/*InitBox*/
div.initbox {
	background-color:whitesmoke;
	margin-bottom: 1em;
	border-bottom:1px solid gray;
	clear:left;
	float:left;
	width:100%;
}
div.initbox h2 {
	background-color: #324678;
	border-bottom: 1px solid black;
	color:white;
}
div.initbox div.col {
	padding-left: 10px;
	width:45%;
}

/*Rightcol*/
#rightcol {
	background-color: #eceff0;
	padding-left:0.5em;
	width: 180px;
	float: left;
	border: solid 1px #2d5694;
}
html>body #rightcol ul {
	margin-top: 0;
	padding: 0;
	margin-bottom: 10px;
}

#rightcol ul {
	list-style-type: none;
	margin-top:0;
	margin-bottom: 0.5em;
	 margin-left: 0;
}
#rightcol h3 {
	color: white;
	background-color: #324678;
	font-size: 10pt;
	padding-left:0.5em;
	margin-bottom: 0.5em;
	margin-left: -0.5em;
	border-bottom: 1px solid black;
}

/*Covers many hidden things*/
.hid {
	display:none;
}

/*Pushes Icons into correct position for hybrid project/team pages*/
#documentContainer li
{
 margin-left:25px;
}

/*Form Attributes*/
.form-textshort {
	width: 5em;
}
.form-textmedium {
	width: 10em;
}
.form-textlong {
	width: 15em;
}
.form-textxlong {
	width: 20em;
}
.form-textxxlong {
	width: 25em;
}

.form-textareasmall {
    height: 6ex;
    width: 90%;
}

.form-textareamedium {
    height: 10ex;
    width: 90%;
}

.form-textarealarge {
    height: 20ex;
    width: 90%;
}

.form-textareaxlarge {
    height: 40ex;
    width: 90%;
}

.form-label {
    width: 15em;
    display: block;
    float: left;
	text-align:right;
	margin-right:5px
}

.form-labelshort {
    width: 7em;
    display: block;
    float: left;
	text-align:right;
	margin-right:5px
}

.form-labellong {
    width: 25em;
    display: block;
    float: left;
	text-align:right;
	margin-right:5px
}

.form-input-wrapper {
    margin-bottom: 8px;
}

.required {
	color:red;
}

legend {
	font-weight: bold;
	font-size: 115%;
	padding:15px;
}
      table {
          text-align: center;
          background: #c0c0c0;
          border: 0px;
          cellspacing: 1px;
      }
      
      table thead  {
          cursor: pointer;
      }
      
      table thead tr {
          background: #FFFFFF;
      }
      
      table tbody tr {
          background: #FFFFFF;
      }
      
      td, th {
          border: 1px solid white;
      }
      
      td.cx {
          cursor: auto;
      }
      
      td.c2, th.c2 {
          color: #23FF23;
      }
      
      td.c3, th.c3 {
          color: #EA981C;
      }
 
	  td.c4, th.c4 {
          color: #FF7D1C;
      }
	  
	  td.c5, th.c5 {
          color: #CD853F;
      }
	  
      td.c6, th.c6 {
          color: #FF0000;
      }
      
      td.c7, th.c7 {
          color: #FF0000;
      }
	  
	  td.c8, th.c8 {
          color: #48FFFF;
      }

	  td.c9, th.c9 {
          color: #4169E1;
      }

	  td.c13 {
          color: #00009C;
      }

	  
/*this sheet defines the new table layout properties to move away from floats/containing divs*/
table.layout, div#mainbody {
	width: 900px;
}

td.layout, div#mainbody {
	vertical-align: top;
	text-align: left;
}

td#layout-2col-cr-center, div#mainbody {
	width: 720px;
 	padding-right:5px;
}

td#layout-2col-cr-right {
	width:180px;
}

/*
Main (X)HTML Selectors - Typography, Colours and Positioning 
-------------------------------------------------------------------------[comment] */

body {margin-top:7px}

/*
a normal link is being styled similarly across all pages, unless re-declared
-------------------------------------------------------------------------[comment] */

/*
Tables and related selectors
-------------------------------------------------------------------------[comment] */

/*div table {width:inherit;}*/

/*
the actual border should be visible only when border-width is re-declared
------------------------------------------------------------------[important note] */

/*
page headers - shared typography and positioning 
-------------------------------------------------------------------------[comment] */

p { margin: .3em 0 0 .3em; }

pre {
    color: #990066;
    font-size: 95%;
    font-family: monaco, courier, monospace;
}

ul {
    padding: 0;
    margin: 0;
    list-style-type: none;
}


blockquote {
    color: #333366;
    margin: 2em;
}

code {
    color: #990066;
    font-family: monaco, courier, monospace;
}

sup, sub {
    font-size: 95%;
    font-weight: normal;
}

/*
Form elements 
-------------------------------------------------------------------------[comment] */

form {
    margin: 1em 0;
    padding: 0;
    display: block;
}

button { border: 2px outset #f0f0f0; }

.xar-form-input-wrapper {
    margin-bottom: 4px;
    overflow:auto;
}


/*
replaced elements 
-------------------------------------------------------------------------[comment] */

img { border: 0px; }

/*
list elements 
-------------------------------------------------------------------------[comment] */

/* ul, li, ol { line-height: 125%; } */

/* THEME SPECIFIC CLASSES [gen_heading] */

hr {
    width: 100%;
    color: #c0c0c0;
}

/* XARAYA REQUIRED INDIVIDUAL CLASSES [gen_heading] */
td.xar-norm { }
td.xar-alt { }

/* XARAYA REQUIRED ANONYMOUS CLASSES  [gen_heading] */

/*
these defaults apply to the left and right block group 
-------------------------------------------------------------------------[comment] */

.xar-block-head,
.xar-block-head-right { color: #333399; }


/*HomePage*/
//.xar-block-body {padding:0.5em;}
.xar-block-body, .xar-block-body-right, .xar-block-body-home_page_right {padding:5px; background-color: whitesmoke; border: solid 1px #324678;  }
//.xar-block-body-home_page_right ul {margin-left:5px}
.xar-block-title, .xar-block-title-right, .xar-block-title-home_page_right {color: white; font-weight:bold; text-indent: 0.5em; background-color: #324678; font-size: 10pt; white-space:nowrap;}


.xar-block-body-home_page_left {border:1px solid #324678; padding: 5px; background-color: whitesmoke;}
.xar-block-body-home_page_left ul {margin-left:5px}
.xar-block-title-home_page_left {color: white; font-weight:bold; text-indent: 0.5em; background-color: #324678; font-size: 10pt; }
.xar-block-foot, .xar-block-foot-center, .xar-block-foot-right {}

/*
topnav block group classes 
-------------------------------------------------------------------------[comment] */

.xar-block-head-topnav { }
.xar-block-title-topnav { }
.xar-block-body-topnav { }
.xar-block-foot-topnav { }

/*
center block group classes 
-------------------------------------------------------------------------[comment] */

.xar-block-head-center { width: 100%; }

.xar-block-title-center {
    /*  background-color: inherit; */
    font-weight: bold;
}

.xar-block-body-center { }

.xar-block-foot-center {
    width: 100%;
    margin-bottom: 4px;
}

/*
module rendering area and related rules 
-------------------------------------------------------------------------[comment] */

.xar-mod-head {
color: #2E5191; margin:5px 0 5px 0;
}

span.xar-mod-title {
font-size:14pt;
    font-weight: bold;
}

.xar-mod-body { padding: .3em 0;}
 
.xar-mod-foot { }

/*
complementary styling - colors, backgrounds and outlines 
-------------------------------------------------------------------------[comment] */

.xar-alt { background-color: #f0f0f0; }
.xar-accent { background-color: #efefef; }

.xar-alt-outline {
    border-color: #6699CC;
    border-width: 1px;
    border-style: solid;
}

.xar-accent-outline {
    border-color: #333366;
    border-width: 1px;
    border-style: solid;
}

.xar-norm-outline {
/*
    border-color: #666666;
    border-width: 1px;
    border-style: solid;
    */
}

/*
complementary text related styling
-------------------------------------------------------------------------[comment] */

.xar-norm { background-color: #FFFFFF; }
.xar-sub { font-size: 80%; }
.xar-error { color: #ff0000; }
.xar-title { font-weight: bold; }

/*
not sure if we still using this rule anywhere TODO: check
-------------------------------------------------------------------------[comment] */

/* THEME SPECIFIC ANONYMOUS CLASSES  [gen_heading] */
div#classicthemecontrols {
    position: relative;
    width: 187px;
    float: right;
    padding: 0 3px 0 0;
    margin: 0;
}

div#classicthemecontrols img {
    position: relative;
    float: right;
    width: 26px;
    height: 21px;
}

div.xar-block-body-topnav li, div.xar-block-body-topnav ul {
    display: inline;
    list-style-type: none;
    padding: 0 5px;
    margin: 0;
    border: 0;
} 


/*
since topnav group is available by default, we should take care of it
-------------------------------------------------------------------------[comment] */

/* hide section heading [gen_heading] */
div.xar-block-body-topnav .xar-menu-section h4 { display: none; }


div.xar-block-body-topnav .xar-menu-section ul li a {
    display: inline;
    padding-right: .5em;
    padding-left: .5em;
}

/* all links should display horizontally in topnav block in this theme */
div.xar-block-body-topnav {
    border-color: #757F8B;
    border-width: 1px;
    border-style: solid;
    margin-bottom: 2px;
    padding: 2px 0;
}

/*
positioning and minimal styling of footer 
-------------------------------------------------------------------------[comment] */
/*
div#xc-footer {
    background-image: url(../images/page_bg.gif);
    background-repeat: repeat-x;
    background-position: 0% 20%;
}
*/
/*
footer container itself - watch for the explicit height limitations
-------------------------------------------------------------------------[comment] */

p#footermsg {
    float: right;
    padding: 1px 2px;
    width: 250px;
    text-align: right;
    margin: 0;
}

/*
standard content of the footer, limited by explicit width and height 
-------------------------------------------------------------------------[comment] */

p#slogan {
    float: left;
    padding: 17px 0 0 5px;
    width: auto;
    text-align: left;
    margin: 0;
}


/*
not so much a decoration, but rather a high visibility tool for beta-testers 
-------------------------------------------------------------------------[comment] */

/* MISCELLANEOUS [gen_heading] */
.txttitle {
    font-weight: bold;
    color: #336699;
    text-decoration: none;
}

.sidebtns {
    font-weight: bold;
    color: #336699;
    text-decoration: none;
}

.subhead {
    font-weight: bold;
    color: #60a9f0;
    text-decoration: none;
}

.btns {
    text-decoration: none;
    background-color: #FFD800;
    color: #000000;
    font-weight: bold;
    font-size: 9.5pt;
}

.busbtns {
    text-decoration: none;
    background-color: #85b8ea;
    color: #000000;
    font-weight: bold;
    font-size: 9.5pt;
}

.blk {
    text-decoration: none;
    color: #000000;
    font-weight: bold;
}

.LightUp {
    background-color: #cfe5fa;
    color: #ffffff;
    font-weight: bold;
    text-decoration: none;
}

.LightDown {
    background-color: #ffffff;
    color: #336699;
    font-weight: bold;
    font-size: 9.5pt;
    text-decoration: none;
}

.formUp { background-color: #e3f1ff; }

abbr, acronym, .help {
    border-bottom: 1px dotted #999;
    cursor: help;
}

#globalfooter {width:905px}
    </style>
 </head>
EOF
} else { 

	print outhtml<<EOF;
<html>
  <head>
  <title>PolySpace Batch Results Summary</title>
    <style type="text/css">
/*********** Reset *************/
:focus {
	outline: 0;
}
p, ul, ol {
	margin-top:0px;
}
img {
	border:none;
}
/*Base Styles*/
body, td, th {
	font: 10pt Arial;
	margin-top:7px;
}
body {
	background-color: #fff;
	color: #000;
}
h1 {
	font-size: 16pt;
	color: #2E5191;
	margin-top:0;
}
h2 {
	font-size: 12pt;
	color: #324678;
	padding-left:0.25em;
	padding-bottom: 0.10em;
	margin-top:0;
	margin-bottom: 0.25em;
	background: #F5F5F5;
	border-bottom:1px solid #aaa
}
h3 {
	color: #c86a02;
	font-size: 10pt;
	margin-top: 0;
	margin-bottom: 0;
}
h4 {
	color:maroon;
	font-size: 9pt;
	margin-top:1em;
	margin-bottom:0;
}
h5 {
	color:black;
	font-size: 9pt;
	margin-top:1em;
	margin-bottom:0;
}

a {
	text-decoration: none;
	color: #002bb8;
	background: none;
}
a:link {
	color: #002bb8;
	text-decoration:none;
}
a:visited {
	color: #5a3696;
	text-decoration:none;
}
a:active {
	color: #faa700;
}
a:hover {
	color: #5a3696;
	text-decoration: underline;
}
/*Tables*/
th {
	color: white;
	font-weight:bold;
	background-color: #324678;
	border: #aaa;
	text-align:center;
}
th a:link, th a:visited {
	color:white
}

/* Sortable tables */
table.sortable a.sortheader {
	color:white;
	font-weight: bold;
	text-decoration: none;
	display: block;
}
table.sortable span.sortarrow {
	color: orange;
	text-decoration: none;
}

/* Topnav */
/* Links */

.globalnav a:link,  .globalnav a:visited, .globalnav a:hover {
	font-weight:bold;
	text-decoration:none;
}
.topnav1 a:link, .topnav1 a:visited {
	font-size:10pt;
	color:white
}
.topnav2 a:link, .topnav2 a:visited {
	font-size:8pt;
	color:black
}
.activenavcell a:link, .activenavcell a:visited, .activenavcell a:hover {
	color:white;
}

.topnav1 td, .topnav2 td {
	padding-left:10px;
	padding-right:10px;
}
.topnav1 td {
	padding:3px;
	border-bottom: 1px solid #B0B0B0;
	border-left:1px solid #B0B0B0;
}
.topnav2 td {
	border-right: 1px solid #B0B0B0;
	border-bottom: 1px solid #B0B0B0;
	cursor:hand
}

/*This highlights the topnav1 cell the same as the topnav2 cells */
.topnav1 .activenavcell {
	background-color: maroon;
}
.topnav2 .activenavcell {
	background-color: maroon;
}

/* Cell Backgrounds*/
.topnav1 td {
	background-color: #324678;
}
.topnav2 td {
	background-color: whitesmoke;
}

/*BreadCrumbs*/
#bcrumbs {
	font-size:9pt;
	border-bottom:1px solid lightgrey;
	background: whitesmoke;
}
#bcrumbs a {
	font-size:9pt;
	font-weight:normal;
}
#bcrumbs a:hover {
	text-decoration:underline;
}

/*Popup Menus*/
.menu_lay {
	display:none;
	background-color:#F2F4F8;
	border:1px solid #254987;
	padding:3px;
	white-space: nowrap;
	position:absolute;
}
.menu_lay a {
	text-decoration: none;
	font-weight:normal;
	text-indent: 5px;
}
.menu_lay a:hover {
	text-decoration: none;
}
.menuitem {
	border:1px solid #F2F4F8;
	position:relative;
	width:auto;
}
.menuitem_hover {
	border:1px solid gray;
	background-color:#E3E7F7;
	cursor:hand;
}

/*Mainbody*/
div#mainbody {
	width:740px;
	margin-left: 5px;
}

/*TableTop1*/
.tabletop1 .title {
	color: #244786;
	font-size: 12pt;
	font-weight: bold;
	border-bottom: 1px solid gray;
}
.sectbox1  {
	background-color:#E4E8F1;
	padding-left:5px;
}
.tabletop1 .rtext {
	text-align : right;
	border-bottom: 1px solid gray;
	padding-right: 5px;
}

/*GlobalFooter*/
#globalfooter {
	clear:both;
	float:left;
	width:900px;
	margin-top:20px;
	border-top: 1px solid #324678;
	font-style: italic;
}
#globalfooter a {
	font-weight:bold;
}
#dblclick_footer {
	float:left
}
#contact_footer {
	float:right;
	clear:right;
	text-align:right;
}
#lastmod_footer {
	font-style: normal;
	font-size:8pt;
	clear:right;
	text-align:right;
}

/*Should go away someday - these are legacy hangovers*/
#footertable {
	clear:both;
}
#footertable td {
	border-top: 1px solid #006599;
}

/*Team Homepage Template*/
#header_graphic {
	margin-bottom:20px;
}
#open_area {
	clear:left;
}

/*listcol*/
div.listcol {
	float: left;
	 width: 680px;
}
/*Fix for mozilla ul equalizer - I set to zero and then add the matching bottom pad*/
html>body .listcol ul {
	margin-top: 0;
	padding: 0;
	margin-bottom: 15px;
}
html>body div.row {
	margin-top: 20px;
	padding-top:20px;
}
div.listcol ul {
	list-style-type: none;
	margin-bottom: 15px;
	margin-left: 0
}
div.listcol div.col {
	width: 48%;
	float: left;
}
div.row {
	clear: left;
	margin-bottom:20px;
}
div.spacer {
	float:left;
	width:25px;
	height:10px;
}

/*InitBox*/
div.initbox {
	background-color:whitesmoke;
	margin-bottom: 1em;
	border-bottom:1px solid gray;
	clear:left;
	float:left;
	width:100%;
}
div.initbox h2 {
	background-color: #324678;
	border-bottom: 1px solid black;
	color:white;
}
div.initbox div.col {
	padding-left: 10px;
	width:45%;
}

/*Rightcol*/
#rightcol {
	background-color: #eceff0;
	padding-left:0.5em;
	width: 180px;
	float: left;
	border: solid 1px #2d5694;
}
html>body #rightcol ul {
	margin-top: 0;
	padding: 0;
	margin-bottom: 10px;
}

#rightcol ul {
	list-style-type: none;
	margin-top:0;
	margin-bottom: 0.5em;
	 margin-left: 0;
}
#rightcol h3 {
	color: white;
	background-color: #324678;
	font-size: 10pt;
	padding-left:0.5em;
	margin-bottom: 0.5em;
	margin-left: -0.5em;
	border-bottom: 1px solid black;
}

/*Covers many hidden things*/
.hid {
	display:none;
}

/*Pushes Icons into correct position for hybrid project/team pages*/
#documentContainer li
{
 margin-left:25px;
}

/*Form Attributes*/
.form-textshort {
	width: 5em;
}
.form-textmedium {
	width: 10em;
}
.form-textlong {
	width: 15em;
}
.form-textxlong {
	width: 20em;
}
.form-textxxlong {
	width: 25em;
}

.form-textareasmall {
    height: 6ex;
    width: 90%;
}

.form-textareamedium {
    height: 10ex;
    width: 90%;
}

.form-textarealarge {
    height: 20ex;
    width: 90%;
}

.form-textareaxlarge {
    height: 40ex;
    width: 90%;
}

.form-label {
    width: 15em;
    display: block;
    float: left;
	text-align:right;
	margin-right:5px
}

.form-labelshort {
    width: 7em;
    display: block;
    float: left;
	text-align:right;
	margin-right:5px
}

.form-labellong {
    width: 25em;
    display: block;
    float: left;
	text-align:right;
	margin-right:5px
}

.form-input-wrapper {
    margin-bottom: 8px;
}

.required {
	color:red;
}

legend {
	font-weight: bold;
	font-size: 115%;
	padding:15px;
}
      table {
          text-align: center;
          background: #c0c0c0;
          border: 0px;
          cellspacing: 1px;
      }
      
      table thead  {
          cursor: pointer;
      }
      
      table thead tr {
          background: #FFFFFF;
      }
      
      table tbody tr {
          background: #FFFFFF;
      }
      
      td, th {
          border: 1px solid white;
      }
      
      td.cx {
          cursor: auto;
      }
      
      td.c2, th.c2 {
		color: #EC267C;	
      }
      

	  td.c8, th.c8 {
          color: #25E8F6;
      }

	  td.c9, th.c9 {
          color: #95A9EB;
      }

	  
/*this sheet defines the new table layout properties to move away from floats/containing divs*/
table.layout, div#mainbody {
	width: 900px;
}

td.layout, div#mainbody {
	vertical-align: top;
	text-align: left;
}

td#layout-2col-cr-center, div#mainbody {
	width: 720px;
 	padding-right:5px;
}

td#layout-2col-cr-right {
	width:180px;
}

/*
Main (X)HTML Selectors - Typography, Colours and Positioning 
-------------------------------------------------------------------------[comment] */

body {margin-top:7px}

/*
a normal link is being styled similarly across all pages, unless re-declared
-------------------------------------------------------------------------[comment] */

/*
Tables and related selectors
-------------------------------------------------------------------------[comment] */

/*div table {width:inherit;}*/

/*
the actual border should be visible only when border-width is re-declared
------------------------------------------------------------------[important note] */

/*
page headers - shared typography and positioning 
-------------------------------------------------------------------------[comment] */

p { margin: .3em 0 0 .3em; }

pre {
    color: #990066;
    font-size: 95%;
    font-family: monaco, courier, monospace;
}

ul {
    padding: 0;
    margin: 0;
    list-style-type: none;
}


blockquote {
    color: #333366;
    margin: 2em;
}

code {
    color: #990066;
    font-family: monaco, courier, monospace;
}

sup, sub {
    font-size: 95%;
    font-weight: normal;
}

/*
Form elements 
-------------------------------------------------------------------------[comment] */

form {
    margin: 1em 0;
    padding: 0;
    display: block;
}

button { border: 2px outset #f0f0f0; }

.xar-form-input-wrapper {
    margin-bottom: 4px;
    overflow:auto;
}


/*
replaced elements 
-------------------------------------------------------------------------[comment] */

img { border: 0px; }

/*
list elements 
-------------------------------------------------------------------------[comment] */

/* ul, li, ol { line-height: 125%; } */

/* THEME SPECIFIC CLASSES [gen_heading] */

hr {
    width: 100%;
    color: #c0c0c0;
}

/* XARAYA REQUIRED INDIVIDUAL CLASSES [gen_heading] */
td.xar-norm { }
td.xar-alt { }

/* XARAYA REQUIRED ANONYMOUS CLASSES  [gen_heading] */

/*
these defaults apply to the left and right block group 
-------------------------------------------------------------------------[comment] */

.xar-block-head,
.xar-block-head-right { color: #333399; }


/*HomePage*/
//.xar-block-body {padding:0.5em;}
.xar-block-body, .xar-block-body-right, .xar-block-body-home_page_right {padding:5px; background-color: whitesmoke; border: solid 1px #324678;  }
//.xar-block-body-home_page_right ul {margin-left:5px}
.xar-block-title, .xar-block-title-right, .xar-block-title-home_page_right {color: white; font-weight:bold; text-indent: 0.5em; background-color: #324678; font-size: 10pt; white-space:nowrap;}


.xar-block-body-home_page_left {border:1px solid #324678; padding: 5px; background-color: whitesmoke;}
.xar-block-body-home_page_left ul {margin-left:5px}
.xar-block-title-home_page_left {color: white; font-weight:bold; text-indent: 0.5em; background-color: #324678; font-size: 10pt; }
.xar-block-foot, .xar-block-foot-center, .xar-block-foot-right {}

/*
topnav block group classes 
-------------------------------------------------------------------------[comment] */

.xar-block-head-topnav { }
.xar-block-title-topnav { }
.xar-block-body-topnav { }
.xar-block-foot-topnav { }

/*
center block group classes 
-------------------------------------------------------------------------[comment] */

.xar-block-head-center { width: 100%; }

.xar-block-title-center {
    /*  background-color: inherit; */
    font-weight: bold;
}

.xar-block-body-center { }

.xar-block-foot-center {
    width: 100%;
    margin-bottom: 4px;
}

/*
module rendering area and related rules 
-------------------------------------------------------------------------[comment] */

.xar-mod-head {
color: #2E5191; margin:5px 0 5px 0;
}

span.xar-mod-title {
font-size:14pt;
    font-weight: bold;
}

.xar-mod-body { padding: .3em 0;}
 
.xar-mod-foot { }

/*
complementary styling - colors, backgrounds and outlines 
-------------------------------------------------------------------------[comment] */

.xar-alt { background-color: #f0f0f0; }
.xar-accent { background-color: #efefef; }

.xar-alt-outline {
    border-color: #6699CC;
    border-width: 1px;
    border-style: solid;
}

.xar-accent-outline {
    border-color: #333366;
    border-width: 1px;
    border-style: solid;
}

.xar-norm-outline {
/*
    border-color: #666666;
    border-width: 1px;
    border-style: solid;
    */
}

/*
complementary text related styling
-------------------------------------------------------------------------[comment] */

.xar-norm { background-color: #FFFFFF; }
.xar-sub { font-size: 80%; }
.xar-error { color: #ff0000; }
.xar-title { font-weight: bold; }

/*
not sure if we still using this rule anywhere TODO: check
-------------------------------------------------------------------------[comment] */

/* THEME SPECIFIC ANONYMOUS CLASSES  [gen_heading] */
div#classicthemecontrols {
    position: relative;
    width: 187px;
    float: right;
    padding: 0 3px 0 0;
    margin: 0;
}

div#classicthemecontrols img {
    position: relative;
    float: right;
    width: 26px;
    height: 21px;
}

div.xar-block-body-topnav li, div.xar-block-body-topnav ul {
    display: inline;
    list-style-type: none;
    padding: 0 5px;
    margin: 0;
    border: 0;
} 


/*
since topnav group is available by default, we should take care of it
-------------------------------------------------------------------------[comment] */

/* hide section heading [gen_heading] */
div.xar-block-body-topnav .xar-menu-section h4 { display: none; }


div.xar-block-body-topnav .xar-menu-section ul li a {
    display: inline;
    padding-right: .5em;
    padding-left: .5em;
}

/* all links should display horizontally in topnav block in this theme */
div.xar-block-body-topnav {
    border-color: #757F8B;
    border-width: 1px;
    border-style: solid;
    margin-bottom: 2px;
    padding: 2px 0;
}

/*
positioning and minimal styling of footer 
-------------------------------------------------------------------------[comment] */
/*
div#xc-footer {
    background-image: url(../images/page_bg.gif);
    background-repeat: repeat-x;
    background-position: 0% 20%;
}
*/
/*
footer container itself - watch for the explicit height limitations
-------------------------------------------------------------------------[comment] */

p#footermsg {
    float: right;
    padding: 1px 2px;
    width: 250px;
    text-align: right;
    margin: 0;
}

/*
standard content of the footer, limited by explicit width and height 
-------------------------------------------------------------------------[comment] */

p#slogan {
    float: left;
    padding: 17px 0 0 5px;
    width: auto;
    text-align: left;
    margin: 0;
}


/*
not so much a decoration, but rather a high visibility tool for beta-testers 
-------------------------------------------------------------------------[comment] */

/* MISCELLANEOUS [gen_heading] */
.txttitle {
    font-weight: bold;
    color: #336699;
    text-decoration: none;
}

.sidebtns {
    font-weight: bold;
    color: #336699;
    text-decoration: none;
}

.subhead {
    font-weight: bold;
    color: #60a9f0;
    text-decoration: none;
}

.btns {
    text-decoration: none;
    background-color: #FFD800;
    color: #000000;
    font-weight: bold;
    font-size: 9.5pt;
}

.busbtns {
    text-decoration: none;
    background-color: #85b8ea;
    color: #000000;
    font-weight: bold;
    font-size: 9.5pt;
}

.blk {
    text-decoration: none;
    color: #000000;
    font-weight: bold;
}

.LightUp {
    background-color: #cfe5fa;
    color: #ffffff;
    font-weight: bold;
    text-decoration: none;
}

.LightDown {
    background-color: #ffffff;
    color: #336699;
    font-weight: bold;
    font-size: 9.5pt;
    text-decoration: none;
}

.formUp { background-color: #e3f1ff; }

abbr, acronym, .help {
    border-bottom: 1px dotted #999;
    cursor: help;
}

#globalfooter {width:905px}
    </style>
 </head>
EOF

} 

close(outhtml);
} # end of - generateHTMLHeaderAndStyle

# GetOSShell() :  Compute a string which represents the OS shell on which
sub GetOSShell
{
    for ($^O) {
		/^mswin32$/i && do { debug("OS type: MSWin32\n"); return "mswin32"; };
		/^linux$/i   && do { debug("OS type: Linux\n");   return "linux";   };
#		/^cygwin$/i  && do { debug("OS type: cygwin\n");  return "cygwin";  };
	}
    die "$tool - Fatal error: Unsupported operating system: $^O\n";		
}

sub ldirname
{
  my ($path) = @_;
  debug("-dirname-begin: $path\n");
  $path =~ s/(.)[\\\/]$/\1/;
  if ($path =~ s/^(.*)[\\\/].*/\1/s) {
    if ($path eq "") {
      $path = "/";
    }
  } else {
    $path = ".";
  }
  debug("-dirname-end: $path\n");
  return $path;
}

# Check if path is absoloute or not 
# Add $from to $path when it is relative, i.e. begining with "./" or ".\" 
sub toAbsolutePath
{
    my ($from, $path) = @_;
	debug("toAbsolutePath: BEGIN - $from -- $path \n");
	if ($path =~ /^[a-z]:/i) {
	    # The path is already absolute, make sure there is a '\'
	    # after the drive letter.
	    $path =~ s/^([a-z]:)([^\\\/])/\1\\\2/;
	} elsif ($path =~ /^[\\\/]/) {
			# The path is already absolute, but no drive letter has
		} else {
			# The path is relative. Concatenate it with the current
			# directory.
			# remove .\  ot ./ at the beginning 
			$path =~ s/^\.[\\\/](.*)/\1/;
			my $pwd = $from;
			$path = "$pwd\\" . $path;
	}
    $path =~ s/([^\\\/])$/\1/;
	debug("toAbsolutePath: LAST - $path \n");
    return $path;
}
