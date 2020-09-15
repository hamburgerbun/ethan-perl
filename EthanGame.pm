use warnings;
use strict;

package EthanGame;

our $MAX_PLAYERS = 50;
our $MAX_CHIPS = 1000;
my $DEFAULT_START_CHIPS = 5;

sub new {
    my $class = shift;
    my $opts = shift;
    my $self = {
        'current_player' => 0,
        'turn_count' => 0,
        'ethan' => 0,
        'ethan_eyes' => 0,
        'auto_play' => 0,
        'starting_chips' => $DEFAULT_START_CHIPS,
        'players' => [$DEFAULT_START_CHIPS],
    };

    bless $self, $class;
    if (!$opts) {
        return $self;
    }
    # we assume the opts have already been cleaned up
    $self->{ethan_eyes} = $opts->{e} if $opts->{e};
    $self->{auto_play} = $opts->{a} if $opts->{a};
    $self->{starting_chips} = $opts->{s} if $opts->{s};
    my $player_array = $self->{players};
    my $num_players = $opts->{p};
    for (my $i = 0; $i < $num_players; ++$i) {
        $player_array->[$i] = $self->{starting_chips};
    }
    return $self;
}

sub start_game {
    print "game start!\n";
    my $self = shift;
    while (1) {
        my $did_turn = $self->execute_turn();
        if ($self->check_win_condition() || $self->check_lose_condition()) {
            last;
        }
        $self->increment_player();
        $self->increment_turn() if ($did_turn);
        $self->print_status() if ($did_turn);
    }
}

sub execute_turn {
    my $self = shift;
    my $pl_idx = $self->{current_player};
    if ($self->{players}->[$pl_idx] == 0) {
        return 0;
    }
    print "it is player $pl_idx\'s turn\n";
    if (!$self->{auto_play}) {
        print "hit enter to continue...\n";
        my $garbo = <STDIN>;
    }
    # roll some die
    my $die1 = int(rand(6)) + 1;
    my $die2 = int(rand(6)) + 1;
    print "rolled $die1 and $die2\n";
    if ($self->{ethan_eyes} && ($die1 + $die2) == 2) {
        print "ethan eyes, player $pl_idx loses all chips\n";
        $self->{ethan} += $self->{players}->[$pl_idx];
        $self->{players}->[$pl_idx] = 0;
    } elsif (($die1 + $die2) == 4) {
        print "rolled a 4, player $pl_idx gets all of ethan's chips\n";
        $self->{players}->[$pl_idx] += $self->{ethan};
        $self->{ethan} = 0;
    } else {
        print "player $pl_idx loses a chip\n";
        $self->{ethan} += 1;
        $self->{players}->[$pl_idx] -= 1;
    }
    return 1;
}

sub check_win_condition {
    my $self = shift;
    if ($self->{players}->[$self->{current_player}] == (scalar(@{$self->{players}}) * $self->{starting_chips})) {
        print "player " . $self->{current_player} . " has all of the chips!\n";
        return 1;
    }
    return 0
}

sub check_lose_condition {
    my $self = shift;
    foreach my $pl_val (@{$self->{players}}) {
        if ($pl_val > 0) {
            return 0;
        }
    }
    print "no players have any chips left, Ethan wins\n";
    return 1;
}

sub increment_player {
    my $self = shift;
    $self->{current_player} = ($self->{current_player} + 1) % scalar(@{$self->{players}});
}

sub increment_turn {
    my $self = shift;
    $self->{turn_count} += 1;
}

sub print_status {
    my $self = shift;
    print "Ethan has " . $self->{ethan} . " chips\n";
    for (my $i = 0; $i < scalar(@{$self->{players}}); ++$i) {
        print "Player $i has " . $self->{players}->[$i] . " chips\n";
    }
}