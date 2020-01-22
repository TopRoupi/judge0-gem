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

```ruby
sub = Judge0::Submission.new do |config|
  config.source_code = 'p "Hello world!"'
  config.language_id = 72
end

sub.run # hash of the submission result
sub.stdout # output
```