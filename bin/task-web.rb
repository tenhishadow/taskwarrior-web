#!/usr/bin/env ruby
#
#  Created on 2009-2-27.
#  Copyright (c) 2009. All rights reserved.

require File.expand_path(File.dirname(__FILE__) + "/../lib/taskwarrior-web")
require 'vegas'

Vegas::Runner.new(Taskwarrior::App, 'taskwarrior-web')

