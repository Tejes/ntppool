package NP::Model;
##
## This file is auto-generated *** DO NOT EDIT ***
##
use Combust::DB::Object;
use Combust::DB::Manager;

our $SVN = q$Id$;

{ package NP::Model::Location;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'locations',

  columns => [
    id        => { type => 'integer', not_null => 1 },
    server_id => { type => 'integer', default => '', not_null => 1 },
    zone_id   => { type => 'integer', default => '', not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_key => [ 'server_id', 'zone_id' ],

  foreign_keys => [
    server => {
      class       => 'NP::Model::Server',
      key_columns => { server_id => 'id' },
    },
  
    zone => {
      class       => 'NP::Model::Zone',
      key_columns => { zone_id => 'id' },
    },
  ],
);
}

{ package NP::Model::Location::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::Location' }

__PACKAGE__->make_manager_methods('locations');
}

# Allow user defined methods to be added
eval { require NP::Model::Location }
  or $@ !~ m:^Can't locate NP/Model/Location.pm: and die $@;

{ package NP::Model::LogScore;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'log_scores',

  columns => [
    id        => { type => 'integer', not_null => 1 },
    server_id => { type => 'integer', default => '', not_null => 1 },
    ts        => { type => 'timestamp', not_null => 1 },
    score     => { type => 'scalar', default => '', length => 64, not_null => 1 },
    step      => { type => 'scalar', default => '', length => 64, not_null => 1 },
    offset    => { type => 'scalar', length => 64 },
  ],

  primary_key_columns => [ 'id' ],

  foreign_keys => [
    server => {
      class       => 'NP::Model::Server',
      key_columns => { server_id => 'id' },
    },
  ],
);
}

{ package NP::Model::LogScore::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::LogScore' }

__PACKAGE__->make_manager_methods('log_scores');
}

# Allow user defined methods to be added
eval { require NP::Model::LogScore }
  or $@ !~ m:^Can't locate NP/Model/LogScore.pm: and die $@;

{ package NP::Model::Score;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'scores',

  columns => [
    server_id => { type => 'integer', not_null => 1 },
    ts        => { type => 'timestamp', not_null => 1 },
    score_raw => { type => 'scalar', default => '0', length => 64, not_null => 1 },
  ],

  primary_key_columns => [ 'server_id' ],

  foreign_keys => [
    server => {
      class       => 'NP::Model::Server',
      key_columns => { server_id => 'id' },
      rel_type    => 'one to one',
    },
  ],
);
}

{ package NP::Model::Score::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::Score' }

__PACKAGE__->make_manager_methods('scores');
}

# Allow user defined methods to be added
eval { require NP::Model::Score }
  or $@ !~ m:^Can't locate NP/Model/Score.pm: and die $@;

{ package NP::Model::Server;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'servers',

  columns => [
    id             => { type => 'integer', not_null => 1 },
    ip             => { type => 'varchar', default => '', length => 15, not_null => 1 },
    user_id        => { type => 'integer', default => '', not_null => 1 },
    hostname       => { type => 'varchar', length => 255 },
    stratum        => { type => 'integer' },
    in_pool        => { type => 'integer', default => '', not_null => 1 },
    in_server_list => { type => 'integer', default => '', not_null => 1 },
    netspeed       => { type => 'scalar', default => 1000, length => 8, not_null => 1 },
    created_on     => { type => 'datetime', default => 'now', not_null => 1 },
    updated_on     => { type => 'timestamp', not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_key => [ 'ip' ],

  foreign_keys => [
    user => {
      class       => 'NP::Model::User',
      key_columns => { user_id => 'id' },
    },
  ],

  relationships => [
    locations => {
      class      => 'NP::Model::Location',
      column_map => { id => 'server_id' },
      type       => 'one to many',
    },
  
    log_scores => {
      class      => 'NP::Model::LogScore',
      column_map => { id => 'server_id' },
      type       => 'one to many',
    },
  
    score => {
      class      => 'NP::Model::Score',
      column_map => { id => 'server_id' },
      type       => 'one to one',
    },
  
    server_alert => {
      class      => 'NP::Model::ServerAlert',
      column_map => { id => 'server_id' },
      type       => 'one to one',
    },
  
    server_urls => {
      class      => 'NP::Model::ServerUrl',
      column_map => { id => 'server_id' },
      type       => 'one to many',
    },
  ],
);
}

{ package NP::Model::Server::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::Server' }

__PACKAGE__->make_manager_methods('servers');
}

# Allow user defined methods to be added
eval { require NP::Model::Server }
  or $@ !~ m:^Can't locate NP/Model/Server.pm: and die $@;

{ package NP::Model::ServerAlert;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'server_alerts',

  columns => [
    server_id        => { type => 'integer', not_null => 1 },
    last_score       => { type => 'scalar', default => '0', length => 64, not_null => 1 },
    first_email_time => { type => 'datetime' },
    last_email_time  => { type => 'datetime' },
  ],

  primary_key_columns => [ 'server_id' ],

  foreign_keys => [
    server => {
      class       => 'NP::Model::Server',
      key_columns => { server_id => 'id' },
      rel_type    => 'one to one',
    },
  ],
);
}

{ package NP::Model::ServerAlert::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::ServerAlert' }

__PACKAGE__->make_manager_methods('server_alerts');
}

# Allow user defined methods to be added
eval { require NP::Model::ServerAlert }
  or $@ !~ m:^Can't locate NP/Model/ServerAlert.pm: and die $@;

{ package NP::Model::ServerNote;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'server_notes',

  columns => [
    id        => { type => 'integer', not_null => 1 },
    server_id => { type => 'integer', default => '', not_null => 1 },
    name      => { type => 'varchar', default => '', length => 255, not_null => 1 },
    note      => { type => 'text', default => '', length => 65535, not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_key => [ 'server_id', 'name' ],
);
}

{ package NP::Model::ServerNote::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::ServerNote' }

__PACKAGE__->make_manager_methods('server_notes');
}

# Allow user defined methods to be added
eval { require NP::Model::ServerNote }
  or $@ !~ m:^Can't locate NP/Model/ServerNote.pm: and die $@;

{ package NP::Model::ServerUrl;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'server_urls',

  columns => [
    id        => { type => 'integer', not_null => 1 },
    server_id => { type => 'integer', default => '', not_null => 1 },
    url       => { type => 'varchar', default => '', length => 255, not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  foreign_keys => [
    server => {
      class       => 'NP::Model::Server',
      key_columns => { server_id => 'id' },
    },
  ],
);
}

{ package NP::Model::ServerUrl::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::ServerUrl' }

__PACKAGE__->make_manager_methods('server_urls');
}

# Allow user defined methods to be added
eval { require NP::Model::ServerUrl }
  or $@ !~ m:^Can't locate NP/Model/ServerUrl.pm: and die $@;

{ package NP::Model::User;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'users',

  columns => [
    id             => { type => 'integer', not_null => 1 },
    email          => { type => 'varchar', default => '', length => 255, not_null => 1 },
    name           => { type => 'varchar', length => 255 },
    pass           => { type => 'varchar', length => 255 },
    nomail         => { type => 'enum', default => '0', not_null => 1, values => [ '0', 1 ] },
    bitcard_id     => { type => 'character', length => 40 },
    username       => { type => 'varchar', length => 40 },
    public_profile => { type => 'integer', default => '0', not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_key => [ 'email' ],

  relationships => [
    servers => {
      class      => 'NP::Model::Server',
      column_map => { id => 'user_id' },
      type       => 'one to many',
    },
  ],
);
}

{ package NP::Model::User::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::User' }

__PACKAGE__->make_manager_methods('users');
}

# Allow user defined methods to be added
eval { require NP::Model::User }
  or $@ !~ m:^Can't locate NP/Model/User.pm: and die $@;

{ package NP::Model::Zone;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'zones',

  columns => [
    id          => { type => 'integer', not_null => 1 },
    name        => { type => 'varchar', default => '', length => 255, not_null => 1 },
    description => { type => 'varchar', length => 255 },
    parent      => { type => 'integer' },
    dns         => { type => 'integer', default => 1, not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_key => [ 'name' ],

  foreign_keys => [
    zone => {
      class       => 'NP::Model::Zone',
      key_columns => { parent => 'id' },
    },
  ],

  relationships => [
    locations => {
      class      => 'NP::Model::Location',
      column_map => { id => 'zone_id' },
      type       => 'one to many',
    },
  
    zone_server_counts => {
      class      => 'NP::Model::ZoneServerCount',
      column_map => { id => 'zone_id' },
      type       => 'one to many',
    },
  
    zones => {
      class      => 'NP::Model::Zone',
      column_map => { id => 'parent' },
      type       => 'one to many',
    },
  ],
);
}

{ package NP::Model::Zone::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::Zone' }

__PACKAGE__->make_manager_methods('zones');
}

# Allow user defined methods to be added
eval { require NP::Model::Zone }
  or $@ !~ m:^Can't locate NP/Model/Zone.pm: and die $@;

{ package NP::Model::ZoneServerCount;

use strict;

use base qw(NP::DB::Object);

__PACKAGE__->meta->setup(
  table   => 'zone_server_counts',

  columns => [
    id               => { type => 'integer', not_null => 1 },
    zone_id          => { type => 'integer', default => '', not_null => 1 },
    date             => { type => 'date', default => '', not_null => 1 },
    count_active     => { type => 'scalar', default => '', length => 8, not_null => 1 },
    count_registered => { type => 'scalar', default => '', length => 8, not_null => 1 },
  ],

  primary_key_columns => [ 'id' ],

  unique_key => [ 'zone_id', 'date' ],

  foreign_keys => [
    zone => {
      class       => 'NP::Model::Zone',
      key_columns => { zone_id => 'id' },
    },
  ],
);
}

{ package NP::Model::ZoneServerCount::Manager;

use Combust::DB::Manager;
our @ISA = qw(Combust::DB::Manager);

sub object_class { 'NP::Model::ZoneServerCount' }

__PACKAGE__->make_manager_methods('zone_server_counts');
}

# Allow user defined methods to be added
eval { require NP::Model::ZoneServerCount }
  or $@ !~ m:^Can't locate NP/Model/ZoneServerCount.pm: and die $@;

{ package NP::Model;

  sub dbh { shift; NP::DB::Object->init_db(@_)->dbh; }
  sub db  { shift; NP::DB::Object->init_db(@_);      }

  my @classes = qw(
    NP::Model::Location
    NP::Model::LogScore
    NP::Model::Score
    NP::Model::Server
    NP::Model::ServerAlert
    NP::Model::ServerNote
    NP::Model::ServerUrl
    NP::Model::User
    NP::Model::Zone
    NP::Model::ZoneServerCount
    );
  sub flush_caches {
    $_->meta->clear_object_cache for @classes;
  }

  my $location;
  sub location { $location ||= bless [], 'NP::Model::Location::Manager' }
  my $log_score;
  sub log_score { $log_score ||= bless [], 'NP::Model::LogScore::Manager' }
  my $score;
  sub score { $score ||= bless [], 'NP::Model::Score::Manager' }
  my $server;
  sub server { $server ||= bless [], 'NP::Model::Server::Manager' }
  my $server_alert;
  sub server_alert { $server_alert ||= bless [], 'NP::Model::ServerAlert::Manager' }
  my $server_note;
  sub server_note { $server_note ||= bless [], 'NP::Model::ServerNote::Manager' }
  my $server_url;
  sub server_url { $server_url ||= bless [], 'NP::Model::ServerUrl::Manager' }
  my $user;
  sub user { $user ||= bless [], 'NP::Model::User::Manager' }
  my $zone;
  sub zone { $zone ||= bless [], 'NP::Model::Zone::Manager' }
  my $zone_server_count;
  sub zone_server_count { $zone_server_count ||= bless [], 'NP::Model::ZoneServerCount::Manager' }

}
1;