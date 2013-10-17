#!/usr/bin/perl
=pod

Hello World server

Binds REP socket to tcp://*:5555

Expects "Hello" from client, replies with "World"

Author: Daisuke Maki (lestrrat)
Original version Author: Alexander D'Archangel (darksuji) <darksuji(at)gmail(dot)com>

=cut

use strict;
use warnings;
use 5.10.0;

use ZMQ::LibZMQ3;
use ZMQ::Constants qw(ZMQ_REP);

my $MAX_MSGLEN = 255;

my $context = zmq_init();

# Socket to talk to clients
my $responder = zmq_socket($context, ZMQ_REP);
zmq_bind($responder, 'tcp://*:5555');

while (1) {
    # Wait for the next request from client
    my $message;
    my $size = zmq_recv($responder, $message, $MAX_MSGLEN);
    if ($size == -1) {
        die "Error in zmq_recv: $!";
    }
    if ($size > $MAX_MSGLEN) {
        die "Got message too long for what I expected";
    }
    my $request = substr($message, 0, $size);
    say 'Received request: ['. $request .']';

    # Do some 'work'
    sleep (1);

    # Send reply back to client
    zmq_send($responder, 'World');
}
