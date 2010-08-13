#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 14;

use Protocol::XMLRPC::Dispatcher;
use Protocol::XMLRPC::MethodCall;

my $dispatcher = Protocol::XMLRPC::Dispatcher->new;

my $req = Protocol::XMLRPC::MethodCall->new(name => 'system.listMethods');
$dispatcher->dispatch(
    $req => sub {
        my $res = shift;

        is($res->param->type, 'array');
        is($res->param->data->[0]->value, 'system.getCapabilities');
        is($res->param->data->[1]->value, 'system.listMethods');
        is($res->param->data->[2]->value, 'system.methodHelp');
        is($res->param->data->[3]->value, 'system.methodSignature');
    }
);

$req = Protocol::XMLRPC::MethodCall->new(name => 'system.getCapabilities');
$dispatcher->dispatch(
    $req => sub {
        my $res = shift;

        is($res->param->type, 'struct');
        is($res->param->members->{name}->value,        'introspect');
        is($res->param->members->{specVersion}->value, '1');
        is($res->param->members->{specUrl}->value,
            'http://xmlrpc-c.sourceforge.net/xmlrpc-c/introspection.html');
    }
);

$req = Protocol::XMLRPC::MethodCall->new(name => 'system.methodHelp');
$req->add_param('system.methodHelp');
$dispatcher->dispatch(
    $req => sub {
        my $res = shift;

        is($res->param->type, 'string');
        is($res->param->value, 'Method help');
    }
);

$req = Protocol::XMLRPC::MethodCall->new(name => 'system.methodSignature');
$req->add_param('system.methodHelp');
$dispatcher->dispatch(
    $req => sub {
        my $res = shift;

        is($res->param->type, 'array');
        is($res->param->data->[0]->value, 'string');
        is($res->param->data->[1]->value, 'string');
    }
);
