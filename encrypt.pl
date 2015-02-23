#!/usr/bin/perl -w
use strict;

#Encrypts a text the user enters using one of three methods that the user chooses. Ignores characters with an ascii code less than 32 or greater than 126

my @text;

print "Please enter the text you want to encrypt.\n> ";
my $text_input = <STDIN>;
chomp $text_input;

foreach my $text_chr (split //, $text_input) {
	push @text, $text_chr;
}

print "What method of encryption do you want to use?\n(S)hift Cipher\n(A)ffine Cipher\n(H)ill Cipher\n> ";
my $encrypt_method = <STDIN>;
chomp $encrypt_method;
$encrypt_method = lc($encrypt_method);

($encrypt_method eq 's') ? shift_cipher()
					: ($encrypt_method eq 'a') ? affine_cipher()
					: ($encrypt_method eq 'h') ? hill_cipher()
					: print "$encrypt_method not a valid command.\n";

#print "@text\n";


sub shift_cipher {
	print "Shift Key?\n> ";
	my $shift_key = <STDIN>;
	chomp $shift_key;
	
	my $text_ref = \@text;
	my $text_ref_element_number = 0;
	foreach my $chr (@{$text_ref}) {
		if (ord($chr) >= 32 && ord($chr) <= 126) {
			$chr = chr(((ord($chr) + $shift_key - 32) % 94) + 32);
			$$text_ref[$text_ref_element_number] = $chr;
		}
		$text_ref_element_number++;
	}
	print_encrypted_text();
}

sub affine_cipher {
	print "Affine Cipher: a * (Letter) + b.\nWhat is \"a\"?\n> ";
	my $a = <STDIN>;
	chomp $a;
	print "What is \"b\"?\n> ";
	my $b = <STDIN>;
	chomp $b;
	
	my $text_ref = \@text;
	my $text_ref_element_number = 0;
	foreach my $chr (@{$text_ref}) {
		if (ord($chr) >= 32 && ord($chr) <= 126) {
			$chr = chr((($a * ord($chr) + $b) % 94) + 32);
			$$text_ref[$text_ref_element_number] = $chr;
		}
		$text_ref_element_number++;
	}
	print_encrypted_text();
}

sub hill_cipher {
	my @hill_key;
	my $text_ref_element_number = 0;
	while (1) {
		print "Four digit key (format: 1234)\n> ";
		my $input = <STDIN>;
		chomp $input;
		if ($input =~ /^\d\d\d\d$/) {
			@hill_key = split //, $input;
			last;
		}
		else {
			print "Invalid format\n";
		}
	}
	my @temp_text = @text;
	my $text_ref = \@text;
	while (@temp_text) {
		my ($chr1, $chr2, $encrypted_chr1, $encrypted_chr2);
		if (scalar @temp_text >= 2) {
			$chr1 = shift @temp_text;
			$chr2 = shift @temp_text;
			
			if (ord($chr1) >= 32 && ord($chr1) <= 126) {
				$encrypted_chr1 = chr((((ord($chr1) * $hill_key[0]) + (ord($chr2) * $hill_key[1])) % 94 ) + 32);
				$$text_ref[$text_ref_element_number] = $encrypted_chr1;
				$text_ref_element_number++;
			}
			else {
				$encrypted_chr1 = ord($chr1);
				$$text_ref[$text_ref_element_number] = $encrypted_chr1;
				$text_ref_element_number++;
			}
			
			if (ord($chr2) >= 32 && ord($chr2) <= 126) {
				$encrypted_chr2 = chr((((ord($chr1) * $hill_key[2]) + (ord($chr2) * $hill_key[3])) % 94 ) + 32);
				$$text_ref[$text_ref_element_number] = $encrypted_chr2;
				$text_ref_element_number++;
			}
			else {
				$encrypted_chr2 = ord($chr2);
				$$text_ref[$text_ref_element_number] = $encrypted_chr2;
				$text_ref_element_number++;
			}
		}
		
		if (scalar @temp_text == 1) {
			if (ord($chr1) >= 32 && ord($chr1) <= 126) {
				$encrypted_chr1 = chr((((ord($chr1) * $hill_key[0]) + (ord($chr1) * $hill_key[1])) % 94 ) + 32);
				$$text_ref[$text_ref_element_number] = $encrypted_chr1;
				$text_ref_element_number++;
			}
			else {
				$encrypted_chr1 = ord($chr1);
				$$text_ref[$text_ref_element_number] = $encrypted_chr1;
				$text_ref_element_number++;
			}
		}
	}
	print_encrypted_text();
}

sub print_encrypted_text {
	print "\n\nYour encrypted message:\n";
	my $text_ref = \@text;
	foreach my $chr (@{$text_ref}) {
		print "$chr";
	}
	print "\n";
}