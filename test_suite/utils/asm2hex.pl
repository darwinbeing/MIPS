#!/usr/bin/perl

$tmp=@ARGV;

if($tmp == 0)
{
    $ARGV[0]="sort.s";  #input file name 
    $ARGV[1]="memory";  #output inst and asm files name
}
elsif ($tmp == 1)
{
    $ARGV[1]="memory";#output inst and asm files name
}
elsif ($tmp != 2)
{
    die "invalid argumet num ,the num of the argumet should only be 0,1 or 2!";
}

# Data & ASM file translation

open(FSRC,"$ARGV[0]")       || die "Cannot open input assembly file $ARGV[0] !";
open(FCODE,">$ARGV[1].code")|| die "Cannot open input assembly file $ARGV[1].code !";
open(FASM,">$ARGV[1].asm")  || die "Cannot open input assembly file $ARGV[1].asm !"; 

$writetype = 0;# 0 :write nothing
               # 1 :write code

$last_code_addr = 0;

while(<FSRC>)
{
    if($_ =~ /<.init>/)#if $_ contain "<.init>", set the write code flag
    {
	print "<.init> segment encountered!\n";
	
	$writetype = 1;
	break;
    }
    elsif($_ =~ /<.interrupt>/)#if $_ contain "<.interrupt>", set the write code flag
    {
	print "<.interrupt> segment encountered!\n";
	
	$writetype = 1;
	break;
    }
    elsif($_ =~ /<.text>/)#if $_ contain "<.text>", set the write code flag
    {
	print "<.text> segment encountered!\n";
	
	$writetype = 1;#write code
	break;
    }
    elsif($_=~ /<.rodata>/)
    {
	print "<.rodata> segment encountered!\n";
	    
	$writetype = 1;#write data code
	break;
    }
    elsif($_=~ /<.data>/)
    {
	print "<.data> segment encountered!\n";
	    
	$writetype = 1;#write data code

	break;
    }
    elsif($_=~ /<.got>/)
    {
	print "<.got> segment encountered!\n";
	    
	$writetype = 1;#write data code
	break;
    }
    else
    {
	#print "\$_=$_\n";
	$_=~ s/^ +//;
	#print "\$_=$_\n";
	$_=~ s/ +/ /;
	#$_=~ s/\\t+/ /;
	#print "\$_=$_\n";    
	@words = split(/[\r\t\n\f]/,$_);
	
	chop($words[1]);
	$num =length($words[1]);
	#print "$num\n";
	if($num!=8 )
	{
	    if($_=~ /</ && $_=~ />/)
	    {
		print "Undefined segment encountered!\n";
		$writetype = 0;#write nothing
 	    }
	    break;   
	}
	else
	{
	    #print "IN TRANS\n";
	    #$word =~ s/://;
	    #print "writcode=$writecode,writedata=$writedata\n";
	    
	    if($writetype==1)
	    {
		$cur_code_adr = hex($words[0]);
		if($last_code_addr != 0)
		{
		    $distance = $cur_code_adr - $last_code_addr;
		    if( $distance > 4)
		    {
			if($distance % 4 != 0)
			{
			    print "address error at $words[0] !\n\r";
			}
			else
			{
			    for($i=4;$i<$distance;$i=$i +4)
			    {
				$tmp = sprintf("%x",$last_code_addr+$i);
				#print $tmp."\n";
				print FCODE ("00000000\n");
				print FASM ($tmp.":\tnop\n");
			    }
			}
		    }		    
		}
		$last_code_addr = $cur_code_adr;
		print FCODE ($words[1]."\n");
		print FASM ($words[0]."\t".$words[2]."\t".$words[3]."\n");
		#print  ($words[0]." ".$words[2]." ".$words[3]."\n");
	    }
	}
    }
}

close(FSRC);
close(FCODE);
close(FASM);

