# SubshellCommand

If, like me, you always forget when and how (and why) to use backticks or popen or whatever when trying to execute a shell command from within a ruby process, this should hopefully make life a little bit easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subshell_command'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subshell_command

## Usage

Simplest form:

```ruby
result = SubshellCommand.execute("ls -al")
if result.success?
  puts result.stdout_value
else
  puts result.stderr_value
end
```

But we can do a little better with a block:

```ruby
SubshellCommand.execute("ls -al") do |o|
  o.cmd = "pwd"                       # we can override the command
  o.redirect_stderr_to_stdout = true  # we can pipe stderr to stdout
  o.current_directory = "/"           # we can override the working directory
  o.env = {                           # we can provide some extra env vars
    FOO: "bar"
  }    
  o.on_success = ->(r) do             # we can provide a success callback
    puts r.stdout_value
  end
  o.on_failure = ->(r) do             # we can provide a failure callback
    puts r.stderr_value
  end
end
```

All of the above options have sensible defaults, so you can get away with:

```ruby
SubshellCommand.execute("ls -al") do |o|
  o.on_success = ->(result) do             
    puts result.stdout_value
  end
end
```

If all you care about is doing something when the command succeeds.

Also all the code for this is in one file, which is on purpose, so if you'd rather not add an extra gem, just grab the file, dump it into your project and off you go.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/subshell_command.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
