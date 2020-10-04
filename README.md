# judge0-gem

interface for [judge0 api](https://api.judge0.com/)

## Installation

```bash
gem install judge0
```

or

```ruby
# Gemfile
gem 'judge0'
```

## Usage Examples

### set a custom url

```ruby
  Judge0.base_url = 'http://api.custom-judge0.com'
```

### simple code execution


```ruby
sub = Judge0::Submission.new do |config|
  config.source_code = 'p "Hello world!"'
  config.language_id = 72
end

sub.run # hash of the submission result
sub.stdout # output
```

### wait the response on another thread

```ruby
sub = Judge0::Submission.new do |config|
  config.source_code = 'sleep 2; p "Hello world!"'
  config.language_id = 72
end

sub.get_token

t = Thread.new {
  sub.wait_response!
}

puts "🛏️ waiting..." # doing something while the code is running

t.join

puts sub.output

```

### tests battery execution

```ruby
sub = Judge0::Submission.new do |config|
  config.source_code = 'p gets.to_i'
  config.language_id = 72
end

tests = [
  ['0', '0'],
  ['1', '1']
]

sub.tests_battery(tests)
```

```ruby
sub = Judge0::Submission.new do |config|
  config.source_code = 'p gets.to_i'
  config.language_id = 72
end

tests = [
  {input: '0', output: '0'},
  {input: '1', output: '1'}
]

sub.tests_battery(tests)
```

```ruby
class Test
  attr_accessor :input, :output

  def initialize(input, output)
    @input = input

    @output = output
  end
end

sub = Judge0::Submission.new do |config|
  config.source_code = 'p gets.to_i'
  config.language_id = 72
end

tests = [
  Test.new('0', '0'),
  Test.new('1', '1')
]

sub.tests_battery(tests)
```

### utils

```ruby
require 'pp'
pp Judge0::languages
pp Judge0::statuses
pp Judge0::system_info
pp Judge0::config_info
```

## development

### test

```bash
  irb -Ilib -r judge0
```

### build

```bash
  gem build judge0.gemspec
```

### push

```bash
  gem push judge0-x.x.x.gem
```
