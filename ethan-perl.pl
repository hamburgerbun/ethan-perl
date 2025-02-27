#!/usr/bin/perl

use warnings;
use strict;

use Getopt::Long;
use Data::Dumper;
use EthanGame;

sub main() {
    # parse args
    my $opts = deal_with_options();
    if (!defined($opts)) {
        return 0;
    }
    # initialize game
    my $game = EthanGame->new($opts);
    # run the game
    $game->start_game();
    # that's it
    print "final state of the game:\n";
    print Dumper($game);
}

sub deal_with_options {
    my $ethaneyes = 0;
    my $autoplay = 0;
    my $num_players = 5;
    my $starting_chips = 5;
    my $where_to_output = "";
    my $help_me = 0;
    GetOptions('h' => \$help_me, 'e' => \$ethaneyes, 'a' => \$autoplay, 'p=i' => \$num_players, 's=i' => \$starting_chips);
    if ($help_me) {
        print "ethan_perl.pl [-h] [-e] [-a] [-p <player count>] [-s <starting chip count>]\n";
        print " -h : show help\n";
        print " -e : enable Ethan eyes\n";
        print " -a : autoplay (no hitting enter)\n";
        print " -p : specify number of players (does not count ethan himself)\n";
        print " -s : specify number of starting chips\n";
        return undef;
    }
    if ($num_players < 1) {
        die "need at least 1 player, got $num_players";
    } elsif ($num_players > $EthanGame::MAX_PLAYERS) {
        die "cannot have more than $EthanGame::MAX_PLAYERS, got $num_players";
    } elsif ($starting_chips < 1) {
        die "cannot have 0 or negative starting chips, got $starting_chips";
    } elsif ($starting_chips > $EthanGame::MAX_CHIPS) {
        die "cannot have starting chips over $EthanGame::MAX_CHIPS, got $starting_chips";
    }
    my $opts = {'e' => $ethaneyes, 'a' => $autoplay, 'p' => $num_players, 's' => $starting_chips};
    # TODO: where to output?
    return $opts;
}

main();