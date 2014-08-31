# Modelize  [![wercker status](https://app.wercker.com/status/b2028c39b7ff2ea261857eac4db73af3/s "wercker status")](https://app.wercker.com/project/bykey/b2028c39b7ff2ea261857eac4db73af3)[![Code Climate](https://codeclimate.com/github/yonelacort/modelize/badges/gpa.svg)](https://codeclimate.com/github/yonelacort/modelize)

### Still in development!

Ruby transformer from JSON (as a string), XML, Hash and CSV to an instance class with its attributes.

It transform from objects or files in JSON, XML and CSV. With meta-programming techniques,
the classes are created and instanciated, with their corresponding attributes and respecting object hierarchies.

Handy tool to parse and manipulate HTTP responses, files and objects in the format listed above.

## Installation

Add this line to your application's Gemfile:

    gem 'modelize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install modelize

## Usage

### Instanciate object from JSON string
```ruby
source = "{
  \"root\" : {
    \"key\" : \"value1\",
    \"array_key\" : [1, 2, 3],
    \"object_key\" : {
      \"sub_key\" : 123
    }
  }
}"

instance = Modelize::God.create(source, format: :json)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> 123
```

### Instanciate object from Hash

```ruby
source = {
  "root" => {
    "key" => "value1",
    "array_key" => [1, 2, 3],
    "object_key" => {
      "sub_key" => 123
    }
  }
}

# This format is also supported
# source = {
#   root: {
#     key: "value1",
#     array_key: [1, 2, 3],
#     object_key: {
#       sub_key: 123
#     }
#   }
# }

instance = Modelize::God.create(source, format: :hash)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> 123
```

### Instanciate object from XML file

Having the following XML file whose path is ```console "path/to/file" ```
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<root>
  <key>value1</key>
  <array_key>1</array_key>
  <array_key>2</array_key>
  <array_key>3</array_key>
  <object_key>
    <sub_key1>123</sub_key1>
  </object_key>
</root>
```

```ruby
Modelize::God.create("path/to/file", format: :xml, file: true)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> "123"
```
Note, integers and floats will be returned in string format until fix.

### Instanciate object from JSON file

Having a JSON file whose path is ```console "path/to/file" ```
```json
{
  "root" : {
    "key" : "value",
    "array_key" : [1, 2, 3],
    "object_key" : {
      "sub_key" : 123
    }
  }
}
```

```ruby
Modelize::God.create("path/to/file", format: :json, file: true)
instance.root.key
#=> "value"
instance.root.array_key
#=> [1, 2, 3]
instance.root.object_key.sub_key
#=> 123
```

### Instanciate object from CSV file

Having this CSV file whose path is ```console "path/to/file" ```
```csv
id;name;phone;city;height
1;Tom;123;Valencia;1.78
2;Paul;231;Zurich;1.98
```

```ruby
Modelize::God.create("path/to/file", format: :csv, file: true, separator: ";")
instance.first.name
#=> "Tom"
instance.last.height
#=> "1.98"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/modelize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
